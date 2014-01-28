Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61315 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbaA1QIZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 11:08:25 -0500
Message-ID: <52E7D5F0.9030707@fb.com>
Date: Tue, 28 Jan 2014 11:08:16 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] Btrfs: rework ulist with list+rb_tree
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52E7D273.5080905@fb.com> <38D3E1F0-3519-4EF1-9B78-A872371B3284@gmail.com>
In-Reply-To: <38D3E1F0-3519-4EF1-9B78-A872371B3284@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/28/2014 11:03 AM, Wang Shilong wrote:
> Hello Josef,
>
>> On 01/27/2014 04:59 AM, Wang Shilong wrote:
>>> We are really suffering from now ulist's implementation, some developers
>>> gave their try, and i just gave some of my ideas for things:
>>>
>>>   1. use list+rb_tree instead of arrary+rb_tree
>>>
>>>   2. add cur_list to iterator rather than ulist structure.
>>>
>>>   3. add seqnum into every node when they are added, this is
>>>   used to do selfcheck when iterating node.
>>>
>>> I noticed Zach Brown's comments before, long term is to kick off
>>> ulist implementation, however, for now, we need at least avoid
>>> arrary from ulist.
>>>
>>> Cc: Liu Bo <bo.li.liu@oracle.com>
>>> Cc: Josef Bacik <jbacik@fb.com>
>>> Cc: Zach Brown <zab@redhat.com>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> ---
>>> v2->v3:
>>> 	only do selfchecks with CONFIG_BTRFS_DEBUG enabled(Thanks to Josef!)
>>> 	update ulist's comments since they are out of date.
>>> v1->v2:
>>> 	add RFC title since this patch needs more reviews and comments.
>>> 	fix a used after free bug in ulist_fini().
>> I like the patch but it doesn't build since things like qgroups rely on ulist->nnodes.  You need to fix that in your patch and make sure this stuff compiles.  Thanks,
> Sorry about if it did not compile.
>
> but I really compiled and tested it  in my box, did you apply your qgroup patches?
> This patch is based on btrfs-next without your previous qgroup patches.
>
> Anyway i will double check it…..
>
Yeah I thought I was doing something wrong but I'm definitely on my 
master branch which doesn't have my qgroup patches in it.  If it's still 
working for you now just wait a bit for me to push out this next update 
and rebase onto it and resend.  Thanks,

Josef
