Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43122 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3HDXYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 19:24:09 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so2588998pab.35
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 16:24:09 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 04/12] Btrfs-progs: cleanup similar code in open_ctree_* and close_ctree
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <51FE7B7F.2090206@redhat.com>
Date: Mon, 5 Aug 2013 07:24:04 +0800
Cc: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <4CB8CDC4-A52D-441E-B06A-F5D6A86FFB6D@gmail.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com> <1372857920-4678-5-git-send-email-miaox@cn.fujitsu.com> <51FE7B7F.2090206@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Eric,

I have sent a patch to fix up this regression:
https://patchwork.kernel.org/patch/2828820/

Would you please try and see if this can solve problems.

Thanks,
Wang
> On 7/3/13 8:25 AM, Miao Xie wrote:
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> btrfs-find-root.c | 137 +++-------------
>> disk-io.c         | 473 +++++++++++++++++++++++++++++++-----------------------
>> disk-io.h         |  12 ++
>> 3 files changed, 307 insertions(+), 315 deletions(-)
> 
> This broke at least btrfs-convert:
> 
>> ./btrfs-convert fsfile
>> No valid Btrfs found on fsfile
>> unable to open ctree
>> conversion aborted.
> 
> I read the detailed changelog carefully but it didn't help me
> understand the change, or how it might have broken.  (yes,
> that's sarcasm ;) ).
> 
> Can you take a look & see what is wrong with your change?
> 
> Also, I guess we need a regression test for btrfs-convert.
> 
> -Eric
> 
>> diff --git a/btrfs-find-root.c b/btrfs-find-root.c
>> index da22c1d..f2cc1bf 100644
>> --- a/btrfs-find-root.c
>> +++ b/btrfs-find-root.c
>> @@ -67,74 +67,31 @@ int csum_block(void *buf, u32 len)
>> 
>> static struct btrfs_root *open_ctree_broken(int fd, const char *device)
>> {
>> -	u32 sectorsize;
>> -	u32 nodesize;
>> -	u32 leafsize;
>> -	u32 blocksize;
>> -	u32 stripesize;
>> -	u64 generation;
>> -	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
>> -	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
>> -	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
>> -	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
>> -	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
>> -	struct btrfs_fs_info *fs_info = malloc(sizeof(*fs_info));
>> -	int ret;
> <giant snip>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

