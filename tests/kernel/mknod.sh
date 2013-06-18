#!/bin/bash
#
# mknod.sh : Simple mknod sanity check
#
# Author: Colin Ian King <colin.king@canonical.com>
#
# Copyright (C) 2013 Canonical Ltd.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

test_script_dir=$(dirname $0)
rc=1
test_dir=0

. ${test_script_dir}/../lib/etl_funcs.sh

test_cleanup()
{
	etl_remove_test_dir $test_dir
	etl_umount
	etl_lumount
	etl_unlink_keys
	exit $rc
}
trap test_cleanup 0 1 2 3 15

# TEST
etl_add_keys || exit
etl_lmount || exit
etl_mount_i || exit
test_dir=$(etl_create_test_dir) || exit
test_file="${test_dir}/full"

mknod $test_file c 1 7
#
#  Check to see if mknod succeeded as expected
#
if [ $? -eq 0 ]; then
	dev=$(stat $test_file -c%t:%T)
	if [ $? -eq 0 ]; then
		if [ x$dev == x1:7 ]; then
			rc=0
		fi
	fi
fi

rm -f $test_file

etl_umount || exit
etl_mount_i || exit

exit
