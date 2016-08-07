Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36220 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbcHGU6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Aug 2016 16:58:03 -0400
Received: by mail-io0-f175.google.com with SMTP id b62so342298022iod.3
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Aug 2016 13:58:03 -0700 (PDT)
Date: Sun, 7 Aug 2016 16:57:50 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris McFaul <mcfaul@gmail.com>
Subject: Re: Unmountable and unrepairable BTRFS
Message-ID: <20160807205750.GA22932@solydxk>
References: <CAPT_Aj+gzL6Pnz4JeN2Aco_Enq__3Pd=qYnC4M8=b-8Q=UPTmA@mail.gmail.com>
 <CA+X5Wn5uCAbfBgRM9D3is9_W8rJD_1tRnqUOONKUBxfy3BHi1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+X5Wn5uCAbfBgRM9D3is9_W8rJD_1tRnqUOONKUBxfy3BHi1A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Sat, Aug 06, 2016 at 07:09:40PM -0400, james harvey wrote:
>> On Sat, Aug 6, 2016 at 6:36 PM, Chris McFaul <mcfaul@gmail.com> wrote:
>> Hi, if anyone is able to help with a rather large (34TB of data on it)
>> BTRFS RAID 6 I would be very grateful (pastebins below) - at this
>> point I am only interested in recovery since I am obviously switching
>> to RAID 1 once/if I get my data back.
>>
>> Many thanks in advance
>>
>> Chris
>>
> Depending on how important the data is, wanted to throw out the most
> prudent first step is to get another set of drives equal to or bigger
> than the ones of the bad volume, and image them using dd one by one as
> block devices.  That gives you an undo button if recovery attempts go
> wrong.  Always the best first step in data recovery, if there's not a
> hardware failure involved.
> 
> Depending on the value of the data, it might not be practical as
> you're looking at an expensive set of new drives.  Just wanted to
> throw that out there, in case.
>

Has anyone ever rented a server with massive storage for this?  From what I understand it's possible to rent them short-term...  How much did it cost?  The reason I ask is I imagine it would be cheaper than buying a second set of disks for a huge array.

Cheers,
Nicholas
