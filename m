Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43661 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaJWHkD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 03:40:03 -0400
In-Reply-To: <5447E273.3030901@shiftmail.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com> <5447A5CF.9060405@siedziba.pl> <5447E273.3030901@shiftmail.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: device balance times
From: Russell Coker <russell@coker.com.au>
Date: Thu, 23 Oct 2014 18:39:52 +1100
To: Bob Marley <bobmarley@shiftmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <4720D6B0-A157-4B68-8472-85176B9949A8@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also a device replace operation requires that the replacement be the same size (or maybe larger). While a remove and replace allows the replacement to be merely large enough to contain all the data. Given the size variation in what might be called the same size disk by manufcturers this isn't uncommon - unless you just get a replacement of the next size up (which is a good option too).

On October 23, 2014 3:59:31 AM GMT+11:00, Bob Marley <bobmarley@shiftmail.org> wrote:
>On 22/10/2014 14:40, Piotr Pawłow wrote:
>> On 22.10.2014 03:43, Chris Murphy wrote:
>>> On Oct 21, 2014, at 4:14 PM, Piotr Pawłow<pp@siedziba.pl>  wrote:
>>>> Looks normal to me. Last time I started a balance after adding 6th 
>>>> device to my FS, it took 4 days to move 25GBs of data.
>>> It's long term untenable. At some point it must be fixed. It's way, 
>>> way slower than md raid.
>>> At a certain point it needs to fallback to block level copying, with
>
>>> a ~ 32KB block. It can't be treating things as if they're 1K files, 
>>> doing file level copying that takes forever. It's just too risky
>that 
>>> another device fails in the meantime.
>>
>> There's "device replace" for restoring redundancy, which is fast, but
>
>> not implemented yet for RAID5/6.
>
>"Device replace" on raid 0,1,10 works if the device to be replaced is 
>still alive, otherwise the operation is as long as a rebalance and
>works 
>similarly (AFAIR).
>Which is way too long in terms of the likelihood of another disk
>failing.
>Additionally, it seeks like crazy during the operation, which also 
>greatly increases the likelihood of another disk failing.
>
>Until this is fixed I am not confident in using btrfs on a production 
>system which requires RAID redundancy.
>
>The operation needs to be streamlined: it should be as sequential as 
>possible (sort files according to their LBA before reading/writing), 
>with the fewest number of seeks on every disk, and with large buffers, 
>so that reads from the source disk(s) and writes to the replacement
>disk 
>goes at platter-speed or near there.
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.
