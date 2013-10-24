Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:34213 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3JXPg3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 11:36:29 -0400
Message-ID: <52693E77.30709@jan-o-sch.net>
Date: Thu, 24 Oct 2013 17:36:23 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, dustymabe@gmail.com
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting
 (bug #61951)
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net> <801531AB-DF1E-44AC-B58E-D0388C7FCC55@gmail.com>
In-Reply-To: <801531AB-DF1E-44AC-B58E-D0388C7FCC55@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, October 24, 2013 at 16:49 (+0200), Wang Shilong wrote:
> Hello Jan,
> 
>> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
>> tracking is based on delayed refs. The owner of a tree block is set when a
>> tree block is allocated, it is never updated.
>>
>> When you allocate a tree block and then remove the subvolume that did the
>> allocation, the qgroup accounting for that removal is correct. However, the
>> removal was accounted again for each subvolume deletion that also referenced
>> the tree block, because accounting was erroneously based on the owner.
>>
>> Instead of queueing delayed refs for the non-existent owner, we now
>> queue delayed refs for the root being removed. This fixes the qgroup
>> accounting.
> 
> Thanks for tracking this, i apply your patch, and using the flowing patch,
> found the problem still exist, the test script like the following:

Reproduced. Gives more negative numbers due to accounting triggered by the
cleaner thread, that's the common part here. I still believe that the fix I sent
is correct, it's probably not complete. Looking into it.

Thanks,
-Jan

> #!/bin/sh
> 
> for i in $(seq 1000)
> do
> 	dd if=/dev/zero of=<mnt>/$i""aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  bs=10K count=1
> done
> 
> btrfs sub snapshot <mnt> <mnt>/1
> for i in $(seq 100)
> do
> 	btrfs sub snapshot <mnt>/$i <mnt>/$(($i+1))
> done
> 
> for i in $(seq 101)
> do
> 	btrfs sub delete <mnt>/$i
> done
> 
> 
> Thanks,
> Wang
