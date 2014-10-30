Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47016 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759741AbaJ3Na6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 09:30:58 -0400
Received: by mail-qa0-f46.google.com with SMTP id n8so168176qaq.33
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 06:30:58 -0700 (PDT)
Received: from [10.1.42.124] ([50.241.177.193])
        by mx.google.com with ESMTPSA id f73sm6740455qge.1.2014.10.30.06.30.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 30 Oct 2014 06:30:56 -0700 (PDT)
Message-ID: <54523D86.5040906@gmail.com>
Date: Thu, 30 Oct 2014 09:30:46 -0400
From: Zack Coffey <tech42.clickwir@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com> <54517338.7090606@pobox.com>
In-Reply-To: <54517338.7090606@pobox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rob, That second drive was immediately put to use elsewhere. I figured 
having only the metadata on that drive, it wouldn't matter. The data 
stayed single and wasn't part of the second drive, only the metadata 
was. I must not be capable of understanding why that wouldn't work.

I thought all I was doing was removing a duplication of metadata and the 
worst I would see is a message complaining about a drive missing. Never 
thought the data or access to it could be compromised in what seemed to 
be a simple situation.

Anand, I get the same output with mount -o recovery,ro.

On 10/29/2014 7:07 PM, Robert White wrote:
> On 10/29/2014 03:26 PM, Robert White wrote:
>> On 10/28/2014 01:32 PM, Zack Coffey wrote:
>>> Made a RAID1 with another drive of just the metadata. Was in
>>> that state for less than 12 hours-ish, removed the second drive and
>>> now cannot get to any data on the original drive. Data remained single
>>> while only metadata was RAID1.
>>
>> I don't know all the details but I would _never_ suspect the action you
>> described to _not_ hose up the file system.
>> You need to put the second drive back in and then coerce all the data
>> back to the first drive. "btrfs device delete" is what you want. You
>> _may_ need to switch the metadata back to "single" before the delete.
>>
>> --Rob.
>>
>
> P.S. I am/was assuming you said "removed the second drive" in the 
> normal sense of disconnecting and removing, as opposed to the semantic 
> action of deleting the device element.
>
> If you did do the btrfs delete, you might have needed to do a "btrfs 
> filesystem sync" to make sure that all the transactions involved in 
> the delete were finished and flushed to disk.
>
> Either way, physically reattaching "the second drive" is your first 
> step; presuming again that you haven't destroyed the partition or 
> re-used the drive etc. If the partition will mount once the second 
> drive is in place, do the delete operation (if you didn't) and then 
> the sync (to make sure that everything has finished migrating etc). 
> Then you should be able to re-remove the physical drive.
>
> If you already did the delete and sync as part of what you meant by 
> "remove" then sorry for the interruption of your misery. 8-)
>

