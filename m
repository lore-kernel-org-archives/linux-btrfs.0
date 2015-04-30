Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbD3KgZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 06:36:25 -0400
Date: Thu, 30 Apr 2015 18:36:23 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs: 020 is bit diverted from its objective
Message-ID: <20150430103622.GQ17534@dhcp-13-216.nay.redhat.com>
References: <1430387954-15682-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430387954-15682-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 30, 2015 at 05:59:14PM +0800, Anand Jain wrote:
> Not sure what this test case wanted to achieve by deleting the
> source device before the replace.
> 
> As per the comments the objective of this test case seems to be
> 
> ~~~~
> btrfs device replace test on RO fs
> 
> Regression test for commit:
> bbb651e Btrfs: don't allow the replace procedure on read only filesystems
> ~~~~~
> 
> Also there won't be EIO when you delete a loop device when its
> still mounted. as shown below.
> 
> mount /dev/loop0 /mnt
> losetup -d /dev/loop0
> echo $?
> 0
> dd if=/dev/zero of=/mnt/tf1 count=1
> 1+0 records in
> 1+0 records out
> 512 bytes (512 B) copied, 0.00192936 s, 265 kB/s
> cd /mnt
> sync
> losetup -a
> /dev/loop0: [0802]:1291816 (/root/testdev/disk1)
> 
> No errors in the dmesg as well.
> 
> Instead of further confusing, I am deleting  the delete loop device part

Makes sense to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/btrfs/020 | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/tests/btrfs/020 b/tests/btrfs/020
> index 84251f3..3752dcf 100755
> --- a/tests/btrfs/020
> +++ b/tests/btrfs/020
> @@ -76,8 +76,6 @@ loop_dev3=`_create_loop_device $fs_img3`
>  _mkfs_dev -m raid1 -d raid1 $loop_dev1 $loop_dev2 >>$seqres.full 2>&1
>  _mount -o ro $loop_dev1 $loop_mnt
>  
> -# Fail the second device and replace with the third
> -_destroy_loop_device $loop_dev2
>  $BTRFS_UTIL_PROG replace start -B 2 $loop_dev3 $loop_mnt >>$seqres.full 2>&1 && \
>  _fail "FAIL: Device replaced on RO btrfs"
>  
> -- 
> 2.0.0.153.g79dcccc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
