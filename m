Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:49937 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760143Ab2FUUIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 16:08:31 -0400
Message-ID: <4FE37F3C.2020102@fusionio.com>
Date: Thu, 21 Jun 2012 16:08:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: flush delayed inodes if we're short on space
References: <1340304875-8111-1-git-send-email-jbacik@fusionio.com> <4FE376F3.5030609@zabbo.net>
In-Reply-To: <4FE376F3.5030609@zabbo.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2012 03:33 PM, Zach Brown wrote:
>
>> +	case FLUSH_DELAYED_ITEMS_NR:
>> +	case FLUSH_DELAYED_ITEMS:
>> +		nr = (*state == FLUSH_DELAYED_ITEMS_NR) ? 10 : -1;
>
> This 10 seemed awfully magical so I read a bit more.
>
> It appears to be an attempt to pop back up into reserve_metadata_bytes()
> to see if the caller has been satisfied before continuing on to apply
> all the delayed items.
>
> The magic number seems awfully clumsy.  It'll either do too much work or
> will blow through all the delayed items, depending on the load.  Is it
> too hard to have btrfs_run_delayed_items() check for the callers
> reservation and return if there's a chance that it'll be satisfied?
>
> Am I missing something?  Over-thinking a rare path as the initial steps
> will tend to free up space most of the time?
>

Ugh sorry I just dug this patch out from last week and forgot I had just 
picked an arbitrary number to make sure it was working.  You are 
correct, what I _meant_ to do (and will do after I respond) was 
calculate how much we wanted to flush and then divide that by how much 
the delayed inodes reserve and then multiply it by 2 for good measure. 
Does that sound more reasonable?  Thanks,

Josef
