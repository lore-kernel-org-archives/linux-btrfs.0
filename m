Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32798 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbeCVMZ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 08:25:57 -0400
Subject: Re: [PATCH] btrfs-progs: wipe all copies of the stale superblock
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180321101920.9004-1-anand.jain@oracle.com>
 <e16124c3-7f57-6a2f-f760-5164f7c10ad1@suse.com>
 <d2fbba43-dff3-3909-a794-69c4a8ed4ace@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cb036707-14b7-578a-2051-56768a729771@suse.com>
Date: Thu, 22 Mar 2018 14:25:54 +0200
MIME-Version: 1.0
In-Reply-To: <d2fbba43-dff3-3909-a794-69c4a8ed4ace@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.03.2018 14:14, Anand Jain wrote:
> 
> 
>  Ok. Will update the change log.
> 
>> A better place for this code is really inside btrfs_wipe_existing_sb.
>> Furthermore looking at libblkid it supports a way to wipe multiple
>> superblocks by way of: blkid_do_wipe. I.e
>> https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.21/libblkid-docs/libblkid-Low-level-tags.html#blkid-do-wipe
>>
>>
>> Apparently this functionality has been in libblkid for quite some time
>> according to this blog post -
>> http://karelzak.blogspot.bg/2011/11/wipefs8-improvements.html (Karel Zak
>> is the person mainting various system libraries).
>>
>> So can't we at the very least:
>>
>> 1) Remove some of our (open coded) implementation of
>> btrfs_wipe_existing_sb and use the generic blkid implementation.
>>
>> 2) Incorporate your code into btrfs_wipe_existing_sb OR extend the usage
>> of the generic blkid_do_wipe to wipe multiple copies of the sb ?
> 
>  In btrfs_prepare_device() we have already zeroed the SBs which were
>  within the block count. The btrfs_wipe_existing_sb() is to handle the
>  other type of FS SBs. Definitely, we can consolidate all this into a
>  single function using libblkid. However, it can be done in a separate
>  patch.

So I misread the code in the beginning, so the actual btrfs SB are being
wiped out by the for loop which calls zer_dev_clamped. And in there all
superblocks between  0 - block_count are zeored. And block_count is
actual physical size of the device, right. And this value can further be
limited by the max_block_count being passed, which in mkfs case is
what's passed to -b.

So instead of adding more code, why not just call zero_dev_clamped with
the return value of btrfs_device_size rather than the possibly clamped
one block_count? That you always unconditionally will be sure to zero
out all the sb which are on the device, irrespective of the size of the
fs? Something like :

diff --git a/utils.c b/utils.c
index 715bab0ebfb5..17df72c3a1d5 100644
--- a/utils.c
+++ b/utils.c
@@ -316,7 +316,7 @@ static int btrfs_wipe_existing_sb(int fd)
 int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
                u64 max_block_count, unsigned opflags)
 {
-       u64 block_count;
+       u64 block_count, device_size;
        struct stat st;
        int i, ret;

@@ -326,7 +326,7 @@ int btrfs_prepare_device(int fd, const char *file,
u64 *block_count_ret,
                return 1;
        }

-       block_count = btrfs_device_size(fd, &st);
+       block_count = device_size = btrfs_device_size(fd, &st);
        if (block_count == 0) {
                error("unable to determine size of %s", file);
                return 1;
@@ -351,7 +351,7 @@ int btrfs_prepare_device(int fd, const char *file,
u64 *block_count_ret,
        ret = zero_dev_clamped(fd, 0, ZERO_DEV_BYTES, block_count);
        for (i = 0 ; !ret && i < BTRFS_SUPER_MIRROR_MAX; i++)
                ret = zero_dev_clamped(fd, btrfs_sb_offset(i),
-                                      BTRFS_SUPER_INFO_SIZE, block_count);
+                                      BTRFS_SUPER_INFO_SIZE, device_size);

