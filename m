Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54921 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaJWQ2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 12:28:23 -0400
Received: by mail-pd0-f175.google.com with SMTP id y13so1310152pdi.6
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 09:28:22 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: "Transaction commit" in btrfs sub del
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20141023221803.13832b4e@natsu>
Date: Fri, 24 Oct 2014 00:28:08 +0800
Cc: =?utf-8?Q?Piotr_Paw=C5=82ow?= <pp@siedziba.pl>,
        linux-btrfs@vger.kernel.org
Message-Id: <D3C66968-2395-451D-8296-202A1207EE6E@gmail.com>
References: <20141023202411.701bd1f3@natsu> <5449226E.606@siedziba.pl> <20141023221803.13832b4e@natsu>
To: Roman Mamedov <rm@romanrm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 23 Oct 2014 17:44:46 +0200
> Piotr Pawłow <pp@siedziba.pl> wrote:
> 
>> On 23.10.2014 16:24, Roman Mamedov wrote:
>>> I was under impression that the "Transaction commit:" setting in 'btrfs sub
>>> del' finally allows us to make it not return until all free space from the
>>> snapshots that are being deleted, is completely freed up.
>> 
>> This is not what "commit-each" or "commit-after" options do. These are 
>> only to make sure, that the deletion is commited and the subvolume 
>> doesn't reappear after a crash.
> 
> But is that not already ensured by a regular 'sync', or 'btrfs fi sync’?

They could have same effects..
but doing ’sync’ is much more heavy than options..


> 
>> You probably want "subvolume sync" command, introduced in btrfs-progs 3.17:
>> 
>> btrfs subvolume sync <path> [<subvol-id>...]
>>         Wait until given subvolume(s) are completely removed from the 
>> filesystem.
> 
> Oh right, *that*'s the one I was thinking of.
> 
> -- 
> With respect,
> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

