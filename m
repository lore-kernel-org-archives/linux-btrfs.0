Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:48067 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAWJh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 04:37:27 -0500
Subject: RE: Recovery Operation With Multiple Devices
From: =?utf-8?Q?Brett_King?= <brett.king@commandict.com.au>
To: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>,
        =?utf-8?Q?Brendan_Hide?= <brendan@swiftspirit.co.za>
Date: Fri, 23 Jan 2015 20:37:24 +1100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.54c21654.532e.08ee9fa1411c5834@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----Original message-----
From:	Brendan Hide <brendan@swiftspirit.co.za>
Sent:	Fri 01-23-2015 08:18 pm
Subject:	Re: Recovery Operation With Multiple Devices
To:	Brett King <brett.king@commandict.com.au>; linux-btrfs@vger.kernel.org; 
> On 2015/01/23 09:53, Brett King wrote:
> > Hi All,
> > Just wondering how 'btrfs recovery' operates
> I'm assuming you're referring to a different set of commands or general 
> scrub/recovery processes. AFAIK there is no "btrfs recovery" command.
> 

Oh yes, my apologies - I did mean 'btrfs restore' as a means of recovery.

> > , when the source device given is one of many in an MD array - I can't find 
> anything documentation beyond a single device use case.
> btrfs doesn't know what an md array or member is, therefore your results 
> aren't going to be well-defined. Depending on the type of md array the 
> member was in, your data may be mostly readable (RAID1) or 
> completely/mostly non-interpretable (RAID5/6/10/0) until md fixes the array.
> 

Apologies again, by 'MD' I mean btrfs multiple devices not the MD for block-level RAID via mdadm.

> > Does it automatically include all devices in the relevant MD array as occurs 
> when mounting, or does it only restore the data which happened to be written to 
> the specific, single device given ?
> As above, btrfs is not md-aware. It will attempt to work with what it is 
> given. It might not understand anything it sees as it will not have a 
> good description of what it is looking at. Imagine being given 
> instructions on how to get somewhere only to find that the first 20 
> instructions and every second instruction thereafter was skipped and 
> there's a 50% chance the destination doesn't exist.
> 
> >  From an inverse perspective, how can I restore all data including snapshots, 
> which are spread across a damaged MD FS to a new (MD) FS ?
> Your best bet is to restore the md array. More details are needed for 
> anyone to assist - for example what RAID-type was the array set up with, 
> how many disks were in the array, and how it failed. Also, technically 
> this is the wrong place to ask for advice about restoring md arrays. ;)
> 

The FS is btrfs RAID1 and gets forced readonly from what appears to be related to the 3.17 snapshot bug.

> > Can send / receive do this perhaps ?
> Send/receive is for sending good data to a destination that can accept 
> it. This, as above, depends on the data being readable/available. Very 
> likely the data will be unreadable from a single disk unless the md 
> array was RAID1.
> 

I can read the data fine and tried the 'btrfs restore -sxv', which appeared to do what I wanted but I don't yet have enough space on the restore target to confirm that it gets more data than the single source disk I specify on the command.

> > Thanks in advance !
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -- 
> __________
> Brendan Hide
> http://swiftspirit.co.za/
> http://www.webafrica.co.za/?AFF1E97
> 
>
