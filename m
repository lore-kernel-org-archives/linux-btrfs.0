Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35520 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbbIDGRs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 02:17:48 -0400
Message-ID: <55E93711.6040006@oracle.com>
Date: Fri, 04 Sep 2015 14:15:45 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>
CC: fstests@vger.kernel.org, david@fromorbit.com, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com
Subject: Re: [PATCH v8 1/3] xfstests: btrfs: add functions to create dm-error
 device
References: <1440477568-4614-1-git-send-email-anand.jain@oracle.com> <1440477568-4614-2-git-send-email-anand.jain@oracle.com> <20150831061520.GA538@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20150831061520.GA538@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Eryu,

  Thanks for commenting.
  sorry for the delay other stuff took precedence for a while. more below..

On 08/31/2015 02:15 PM, Eryu Guan wrote:
> On Tue, Aug 25, 2015 at 12:39:26PM +0800, Anand Jain wrote:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> Controlled EIO from the device is achieved using the dm device.
>> Helper functions are at common/dmerror.
>>
>> Broadly steps will include calling _dmerror_init().
>> _dmerror_init() will use SCRATCH_DEV to create dm linear device and assign
>> DMERROR_DEV to /dev/mapper/error-test.
>>
>> When test script is ready to get EIO, the test cases can call
>> _dmerror_load_table() which then it will load the dm error.
>> so that reading DMERROR_DEV will cause EIO. After the test case is
>> complete, cleanup must be done by calling _dmerror_cleanup().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> ---
>> v7->v8:
>>   . Mainly avoid duplicate lines of code, create reusable functions
>>    _common_dev_mount_options(), dmerror_mount_options(),
>>    _dmerror_mount()
>>   . Update _scratch_mount_option() to use _common_dev_mount_options()
>>
>> v6->v7:
>>   rename _init_dmerror() to _dmerror_init()
>>   remove _scratch_mkfs_dmerror()
>>   rename _mount_dmerror() to _dmerror_mount()
>>   rename _cleaup_dmerror() to _dmerror_cleanup()
>>   rename _load_dmerror_table() to _dmerror_load_table()
>>   rename BLK_DEV_SIZE to blk_dev_size
>>   remove _unmount_dmerror there were no consumer of it
>>   use _fail instead of _fatal in rc/dmerror
>>   update error log to make crisp sense
>>   move _require_dmerror() from common/rc to common/dmerror and rename
>>     it to dmerror_required() so that its consistent with other function
>>     names with in the file
>>
>> v5->v6: accepts Eryu's comments, thanks
>>   . added missing $MKFS_OPTIONS at _scratch_mkfs_dmerror()
>>   . used $MOUNT_PROG instead of mount at _mount_dmerror()
>>   . correct typo $UMOUNT_PROG, no S at the end in _unmount_dmerror()
>>
>> v4->v5: No Change. keep up with the patch set
>>
>> v3->v4: rebase on latest xfstests code
>>
>> v2.1->v3: accepts Filipe Manana's review comments, thanks
>>   . correct if else statement in _require_dm_error()
>>   . fix indent
>>     (a missed Dave comment in v1. looks like I goofed with git cli)
>>
>> v2->v2.1: fixed missed typo error fixup in the commit.
>>
>> v1->v2: accepts Dave Chinner's review comments, thanks
>>   . use SCRATCH_DEV for dmerror backing device
>>   . remove duplicate check of DM_BLK_DEV in _init_dm_error_dev()
>>   . remove a wrong check when reading block size in _init_dm_error_dev()
>>   . remove a wrong check with blockdev --setra in _init_dm_error_dev()
>>   . remove unnecessary check in _load_dm_error_table()
>>   . remove unnecessary dmerror device test by using dd
>>
>>   common/dmerror | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   common/rc      | 13 +++++++++--
>>   2 files changed, 85 insertions(+), 2 deletions(-)
>>   create mode 100644 common/dmerror
>>
>> diff --git a/common/dmerror b/common/dmerror
>> new file mode 100644
>> index 0000000..8ba2262
>> --- /dev/null
>> +++ b/common/dmerror
>> @@ -0,0 +1,74 @@
>> +##/bin/bash
>> +#
>> +# Copyright (c) 2015 Oracle.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#
>> +#
>> +# common functions for setting up and tearing down a dmerror device
>> +
>> +# this test requires the device mapper error target
>> +#
>> +_dmerror_required()
>
> I think this should be renamed to _require_dmerror or _require_dm_error,
> following the naming convention through xfstests, and be moved to
> common/rc, see _require_dm_flakey in common/rc

  It was named as _require_dmerror() in v6. and was changed per Dave 
Chinner comment about naming [1].

  Also in v6 this function was in common/rc file, and further to his 
comment[1] it was moved to the file dmerror.

[1] http://patchwork.kernerl.xyz/patch/7016051/


>> +{
>> +	_require_command "$DMSETUP_PROG" dmsetup
>
> Need these two "requires" too
>
> 	_require_block_device $SCRATCH_DEV
> 	_require_sane_bdev_flush $SCRATCH_DEV

  got it. added. thanks.

>> +	$DMSETUP_PROG targets | grep error >/dev/null 2>&1
>
> modprobe dm-error first? in case dm-error built as a module, as what
> _require_dm_flakey does.

error target is provided by the module dm-mod, so unless like in 
dm-flakey it gets loaded when dmsetup command is called. just in case if 
thats not true in your system (?).. I have included it in v9 and as 
there is no harm as well. thanks.

>> +	[ $? -ne 0 ] && _notrun "This test requires dm error support"
>> +}
>> +
>> +_dmerror_init()
>
> I notice that all dm-error functions are named as _dmerror_xxx and
> dm-flakey functions are named as _xxx_flakey, do we need to stick to the
> same naming scheme as in flakey test? If that doesn't matter I prefer
> the _dmerror_xxx format, personally :)

  yes. to be consistent with flakey it was all named as xxx_dmerror in 
v6 and below. However per Dave comment in v6[1] it was renamed to 
_dmerror_xxx. I am ok with either ways.

  Sent out v9. excluding the rename changes requested sorry.

Thanks, Anand


> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
