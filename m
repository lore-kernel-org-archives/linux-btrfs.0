Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47784 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaCPXkk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 19:40:40 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so4811991pdj.23
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Mar 2014 16:40:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140316231729.GA29149@merlins.org>
Date: Sun, 16 Mar 2014 16:40:39 -0700
Message-ID: <CAN05THRgQ6J4uL_Xmh0FFs7EaBUsAYk97ETZCnMO8QT+6pU4Jg@mail.gmail.com>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
 <20140316231729.GA29149@merlins.org>

On Sun, Mar 16, 2014 at 4:17 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Sun, Mar 16, 2014 at 05:12:10PM -0600, Chris Murphy wrote:
>>
>> On Mar 16, 2014, at 4:55 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> > Then use btrfs replace start.
>>
>> Looks like in 3.14rc6 replace isn't yet supported. I get "dev_replace cannot yet handle RAID5/RAID6".
>>
>> When I do:
>> btrfs device add <new> <mp>
>>
>> The command hangs, no kernel messages.
>
> Ok, that's kind of what I thought.
> So, for now, with raid5:
> - btrfs seems to handle a drive not working
> - you say I can mount with the drive missing in degraded mode (I haven't
>   tried that, I will)
> - but no matter how I remove the faulty drive, there is no rebuild on a
>   new drive procedure that works yet
>
> Correct?

There was a discussion a while back that suggested that a "balance"
would read all blocks and write them out again and that would recover
the data.

I have no idea if that works or not.
Only do this as a last resort once you have already considered all
data lost forever.
