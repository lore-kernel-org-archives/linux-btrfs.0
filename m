Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61011 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaA1QDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 11:03:05 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so526581pbc.32
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 08:03:04 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3 1/2] Btrfs: rework ulist with list+rb_tree
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <52E7D273.5080905@fb.com>
Date: Wed, 29 Jan 2014 00:03:05 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Message-Id: <38D3E1F0-3519-4EF1-9B78-A872371B3284@gmail.com>
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52E7D273.5080905@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello Josef,

> 
> On 01/27/2014 04:59 AM, Wang Shilong wrote:
>> We are really suffering from now ulist's implementation, some developers
>> gave their try, and i just gave some of my ideas for things:
>> 
>>  1. use list+rb_tree instead of arrary+rb_tree
>> 
>>  2. add cur_list to iterator rather than ulist structure.
>> 
>>  3. add seqnum into every node when they are added, this is
>>  used to do selfcheck when iterating node.
>> 
>> I noticed Zach Brown's comments before, long term is to kick off
>> ulist implementation, however, for now, we need at least avoid
>> arrary from ulist.
>> 
>> Cc: Liu Bo <bo.li.liu@oracle.com>
>> Cc: Josef Bacik <jbacik@fb.com>
>> Cc: Zach Brown <zab@redhat.com>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>> v2->v3:
>> 	only do selfchecks with CONFIG_BTRFS_DEBUG enabled(Thanks to Josef!)
>> 	update ulist's comments since they are out of date.
>> v1->v2:
>> 	add RFC title since this patch needs more reviews and comments.
>> 	fix a used after free bug in ulist_fini().
> 
> I like the patch but it doesn't build since things like qgroups rely on ulist->nnodes.  You need to fix that in your patch and make sure this stuff compiles.  Thanks,

Sorry about if it did not compile.

but I really compiled and tested it  in my box, did you apply your qgroup patches?
This patch is based on btrfs-next without your previous qgroup patches.

Anyway i will double check it….. 

Thanks,
Wang
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

