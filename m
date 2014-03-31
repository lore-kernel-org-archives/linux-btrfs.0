Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54057 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaCaIly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 04:41:54 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 67B6F3EE1A7
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 17:41:53 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 59FAA45DF3C
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 17:41:53 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4054F45DF3B
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 17:41:53 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2F17FE18002
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 17:41:53 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id CCAA0E18001
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 17:41:52 +0900 (JST)
Message-ID: <53392A24.4020702@jp.fujitsu.com>
Date: Mon, 31 Mar 2014 17:41:08 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH] Btrfs: fix memory leak in btrfs_create_tree()
References: <201303210432.AA00023@FM-323941448.jp.fujitsu.com> <CAOcd+r22WnYSEns8Aw51=Qp4m3e-kweaxPG-m2+SvkboLtDsWA@mail.gmail.com>
In-Reply-To: <CAOcd+r22WnYSEns8Aw51=Qp4m3e-kweaxPG-m2+SvkboLtDsWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On 2014/03/28 0:50, Alex Lyakas wrote:
> Hi Tsutomu Itoh,
>
> On Thu, Mar 21, 2013 at 6:32 AM, Tsutomu Itoh <t-itoh@jp.fujitsu.com> wrote:
>> We should free leaf and root before returning from the error
>> handling code.
>>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>>   fs/btrfs/disk-io.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 7d84651..b1b5baa 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1291,6 +1291,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>>                                        0, objectid, NULL, 0, 0, 0);
>>          if (IS_ERR(leaf)) {
>>                  ret = PTR_ERR(leaf);
>> +               leaf = NULL;
>>                  goto fail;
>>          }
>>
>> @@ -1334,11 +1335,16 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>>
>>          btrfs_tree_unlock(leaf);
>>
>> +       return root;
>> +
>>   fail:
>> -       if (ret)
>> -               return ERR_PTR(ret);
>> +       if (leaf) {
>> +               btrfs_tree_unlock(leaf);
>> +               free_extent_buffer(leaf);
> I believe this is not enough. Few lines above, another reference on
> the root is taken by
> root->commit_root = btrfs_root_node(root);

Thank you for pointing this out.

You are right.
Could you re-post your fix by the patch submitting form?

Thanks,
Tsutomu

>
> So I believe the proper fix would be:
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d9698fd..260af79 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1354,10 +1354,10 @@ struct btrfs_root *btrfs_create_tree(struct
> btrfs_trans_handle *trans,
>          return root;
>
>   fail:
> -       if (leaf) {
> +       if (leaf)
>                  btrfs_tree_unlock(leaf);
> -               free_extent_buffer(leaf);
> -       }
> +       free_extent_buffer(root->node);
> +       free_extent_buffer(root->commit_root);
>          kfree(root);
>
>          return ERR_PTR(ret);
>
>
>
> Thanks,
> Alex.
>
>
>
>> +       }
>> +       kfree(root);
>>
>> -       return root;
>> +       return ERR_PTR(ret);
>>   }
>>
>>   static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
>>


