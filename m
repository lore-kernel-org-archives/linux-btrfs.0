Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57690 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaA1QVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 11:21:51 -0500
Received: by mail-pd0-f173.google.com with SMTP id y10so529208pdj.18
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 08:21:51 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3 1/2] Btrfs: rework ulist with list+rb_tree
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52E7D5F0.9030707@fb.com>
Date: Wed, 29 Jan 2014 00:21:52 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Message-Id: <7CD39CED-2A9A-478E-97FE-B2D7457386C9@gmail.com>
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52E7D273.5080905@fb.com> <38D3E1F0-3519-4EF1-9B78-A872371B3284@gmail.com> <52E7D5F0.9030707@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> 
> On 01/28/2014 11:03 AM, Wang Shilong wrote:
>> Hello Josef,
>> 
>>> On 01/27/2014 04:59 AM, Wang Shilong wrote:
>>>> We are really suffering from now ulist's implementation, some developers
>>>> gave their try, and i just gave some of my ideas for things:
>>>> 
>>>>  1. use list+rb_tree instead of arrary+rb_tree
>>>> 
>>>>  2. add cur_list to iterator rather than ulist structure.
>>>> 
>>>>  3. add seqnum into every node when they are added, this is
>>>>  used to do selfcheck when iterating node.
>>>> 
>>>> I noticed Zach Brown's comments before, long term is to kick off
>>>> ulist implementation, however, for now, we need at least avoid
>>>> arrary from ulist.
>>>> 
>>>> Cc: Liu Bo <bo.li.liu@oracle.com>
>>>> Cc: Josef Bacik <jbacik@fb.com>
>>>> Cc: Zach Brown <zab@redhat.com>
>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>> ---
>>>> v2->v3:
>>>> 	only do selfchecks with CONFIG_BTRFS_DEBUG enabled(Thanks to Josef!)
>>>> 	update ulist's comments since they are out of date.
>>>> v1->v2:
>>>> 	add RFC title since this patch needs more reviews and comments.
>>>> 	fix a used after free bug in ulist_fini().
>>> I like the patch but it doesn't build since things like qgroups rely on ulist->nnodes.  You need to fix that in your patch and make sure this stuff compiles.  Thanks,
>> Sorry about if it did not compile.
>> 
>> but I really compiled and tested it  in my box, did you apply your qgroup patches?
>> This patch is based on btrfs-next without your previous qgroup patches.
>> 
>> Anyway i will double check it…..
>> 
> Yeah I thought I was doing something wrong but I'm definitely on my master branch which doesn't have my qgroup patches in it.  If it's still working for you now just wait a bit for me to push out this next update and rebase onto it and resend.  Thanks,
> 
oops, i noticed what was wrong here, i am sorry for inconvenience  for you!~_~
I will resend this patch right now.

Wang
> Josef

