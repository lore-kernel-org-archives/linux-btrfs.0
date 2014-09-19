Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52712 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaISGpR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 02:45:17 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 75F7C3EE0EC
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 15:45:15 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7B14AAC07A2
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 15:45:14 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 13B8F1DB8041
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 15:45:14 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id D8EC2584371
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 15:45:12 +0900 (JST)
Message-ID: <541BD0F1.7080305@jp.fujitsu.com>
Date: Fri, 19 Sep 2014 15:45:05 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] btrfs: correct a message on setting nodatacow
References: <541A9717.5000003@jp.fujitsu.com> <541A979D.8060409@jp.fujitsu.com> <541B8F08.5020102@cn.fujitsu.com>
In-Reply-To: <541B8F08.5020102@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Thank you for your comment.

(2014/09/19 11:03), Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: [PATCH 2/5] btrfs: correct a message on setting nodatacow
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
> Date: 2014年09月18日 16:28
>> From: Naohiro Aota <naota@elisp.net>
>>
>> If we set nodatacow mount option after compress-force option,
>> we don't get compression disabling message.
>>
>> ===
>> $ sudo mount -o remount,compress-force,nodatacow /; dmesg|tail -n 3
>> [ 3845.719047] BTRFS info (device vda2): force zlib compression
>> [ 3845.719052] BTRFS info (device vda2): setting nodatacow
>> [ 3845.719055] BTRFS info (device vda2): disk space caching is enabled
>> ===
>>
>> Signed-off-by: Naohiro Aota <naota@elisp.net>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> ---
>>   fs/btrfs/super.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index d1c5b6d..d131098 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -462,8 +462,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>>               break;
>>           case Opt_nodatacow:
>>               if (!btrfs_test_opt(root, NODATACOW)) {
>> -                if (!btrfs_test_opt(root, COMPRESS) ||
>> -                    !btrfs_test_opt(root, FORCE_COMPRESS)) {
>> +                if (btrfs_test_opt(root, COMPRESS)) {
>>                       btrfs_info(root->fs_info,
>>                              "setting nodatacow, compression disabled");
>>                   } else {
>> -- 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Although the patch makes the output ok, the core problem is missing conflict options check.
>
> compress-force mount options implies datacow and datasum, but following nodatasum will disable datasum and compress, in fact they are conflicting mount option...
>
> Even the current behavior(later mount option will override previous ones) provides great tolerance,
> IMO there should better be some conflicting check for mount options.
>
> For example, we first save all the mount options passed in into a temporary bitmaps to finds out the conflicting
> and only when they contains no conflicts, set the mount options to fs_info.
> (Maybe bitmap is not enough for this case, since we can't distinguish default value and value to be set?)
>
> What do you think about this idea ?

I'm against your idea for two reasons and it's better to
stay in current behavior though it's a bit complex.

First, the rule "last one wins" is not only a conventional rule,
but also is what mount(8) says.

https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/sys-utils/mount.8#n253

======
The usual behavior is that the last option wins if there are conflicting
ones.
======

Second, if we change the behavior, we would break existing
systems. At worst case, users would fail to boot their system
after updating kernel, because of the failure of mounting
Btrfs at the init process.

Thanks,
Satoru

>
> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

