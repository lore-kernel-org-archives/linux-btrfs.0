Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw4a.wadns.net ([196.220.39.46]:42769 "EHLO fw4a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbbAWL0K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 06:26:10 -0500
Message-ID: <54C211E0.6090403@swiftspirit.co.za>
Date: Fri, 23 Jan 2015 11:18:24 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Brett King <brett.king@commandict.com.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recovery Operation With Multiple Devices
References: <zarafa.54c1fe06.4689.28909bac67ef9272@mascot.commandict.com.au>
In-Reply-To: <zarafa.54c1fe06.4689.28909bac67ef9272@mascot.commandict.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/01/23 09:53, Brett King wrote:
> Hi All,
> Just wondering how 'btrfs recovery' operates
I'm assuming you're referring to a different set of commands or general 
scrub/recovery processes. AFAIK there is no "btrfs recovery" command.

> , when the source device given is one of many in an MD array - I can't find anything documentation beyond a single device use case.
btrfs doesn't know what an md array or member is, therefore your results 
aren't going to be well-defined. Depending on the type of md array the 
member was in, your data may be mostly readable (RAID1) or 
completely/mostly non-interpretable (RAID5/6/10/0) until md fixes the array.

> Does it automatically include all devices in the relevant MD array as occurs when mounting, or does it only restore the data which happened to be written to the specific, single device given ?
As above, btrfs is not md-aware. It will attempt to work with what it is 
given. It might not understand anything it sees as it will not have a 
good description of what it is looking at. Imagine being given 
instructions on how to get somewhere only to find that the first 20 
instructions and every second instruction thereafter was skipped and 
there's a 50% chance the destination doesn't exist.

>  From an inverse perspective, how can I restore all data including snapshots, which are spread across a damaged MD FS to a new (MD) FS ?
Your best bet is to restore the md array. More details are needed for 
anyone to assist - for example what RAID-type was the array set up with, 
how many disks were in the array, and how it failed. Also, technically 
this is the wrong place to ask for advice about restoring md arrays. ;)

> Can send / receive do this perhaps ?
Send/receive is for sending good data to a destination that can accept 
it. This, as above, depends on the data being readable/available. Very 
likely the data will be unreadable from a single disk unless the md 
array was RAID1.

> Thanks in advance !
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

