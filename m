Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34797 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab3DRIfm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 04:35:42 -0400
Message-ID: <516FB0A0.40003@oracle.com>
Date: Thu, 18 Apr 2013 16:36:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: a copy of superblock is zero may not mean
 btrfs is not there
References: <1365753306-19412-1-git-send-email-anand.jain@oracle.com> <20130416115756.GJ18193@twin.jikos.cz> <516E069D.4070103@oracle.com> <20130417171204.GB16427@twin.jikos.cz>
In-Reply-To: <20130417171204.GB16427@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>>> If one of the copy of the superblock is zero it does not
>>>> confirm to us that btrfs isn't there on that disk. When
>>>> we are having more than one copy of superblock we should
>>>> rather let the for loop to continue to check other copies.
>>>>
>>>> the following test case and results would justify the
>>>> fix
>>>>
>>>> mkfs.btrfs /dev/sdb /dev/sdc -f
>>>> mount /dev/sdb /btrfs
>>>> dd if=/dev/zero bs=1 count=8 of=/dev/sdc seek=$((64*1024+64))
>>>> ~/before/btrfs-select-super -s 1 /dev/sdc
>>>> using SB copy 1, bytenr 67108864
>>>>
>>>> here btrfs-select-super just wrote superblock to a mounted btrfs
>>>
>>> Why does not check_mounted() catch this in the first place? Ie. based on
>>> the status in /proc/mounts not on random bytes in the superblock.
>>
>>   the reason is, as of now /proc/mounts just knows about the devid 1.
>
> My oversight, it's mkfs on sdb and select-super on sdc, but then sdc is
> already open and the open(O_EXCL) should prevent that, right? The same
> way mkfs checks whether all the devices are available.

  thanks for the comments.
  checking for O_EXCL would help in a way to avoid this problem.
  but it doesn't address the actual problem.

  here, IMO this is wrong..
------
int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 
sb_bytenr, u64 flags)
{
::
                 /* if magic is NULL, the device was removed */ <----
                 if (buf.magic == 0 && i == 0)
                       return -1;
-----
  since it would inhibits check for the backup superblock
  when the primary superblock is wrongly overwritten with
  zeros.

  eg:
  in general threads which set BTRFS_SCAN_BACKUP_SB flag
  are affected.

  such as btrfs-find-root should fail to work and it
  does as in the below eg: with single disk.

--------
mkfs.btrfs /dev/dm-5 -f
dd if=/dev/zero bs=1 count=8 of=/dev/dm-5 seek=$((64*1024+64))

~/before/btrfs-find-root /dev/dm-5
No valid Btrfs found on /dev/dm-5
Open ctree failed

with the fix:
btrfs-find-root /dev/dm-5
Super think's the tree root is at 29364224, chunk root 20971520
Well block 4194304 seems great, but generation doesn't match, have=2, want=4
Well block 4206592 seems great, but generation doesn't match, have=3, want=4
Found tree root at 29364224
----------

Thanks, Anand
