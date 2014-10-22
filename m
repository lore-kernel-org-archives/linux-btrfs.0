Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:3743 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJVQ7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 12:59:34 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id E97C73133E
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 13:13:47 -0400 (EDT)
Message-ID: <5447E273.3030901@shiftmail.org>
Date: Wed, 22 Oct 2014 18:59:31 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device balance times
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com> <5447A5CF.9060405@siedziba.pl>
In-Reply-To: <5447A5CF.9060405@siedziba.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/10/2014 14:40, Piotr Pawłow wrote:
> On 22.10.2014 03:43, Chris Murphy wrote:
>> On Oct 21, 2014, at 4:14 PM, Piotr Pawłow<pp@siedziba.pl>  wrote:
>>> Looks normal to me. Last time I started a balance after adding 6th 
>>> device to my FS, it took 4 days to move 25GBs of data.
>> It's long term untenable. At some point it must be fixed. It's way, 
>> way slower than md raid.
>> At a certain point it needs to fallback to block level copying, with 
>> a ~ 32KB block. It can't be treating things as if they're 1K files, 
>> doing file level copying that takes forever. It's just too risky that 
>> another device fails in the meantime.
>
> There's "device replace" for restoring redundancy, which is fast, but 
> not implemented yet for RAID5/6.

"Device replace" on raid 0,1,10 works if the device to be replaced is 
still alive, otherwise the operation is as long as a rebalance and works 
similarly (AFAIR).
Which is way too long in terms of the likelihood of another disk failing.
Additionally, it seeks like crazy during the operation, which also 
greatly increases the likelihood of another disk failing.

Until this is fixed I am not confident in using btrfs on a production 
system which requires RAID redundancy.

The operation needs to be streamlined: it should be as sequential as 
possible (sort files according to their LBA before reading/writing), 
with the fewest number of seeks on every disk, and with large buffers, 
so that reads from the source disk(s) and writes to the replacement disk 
goes at platter-speed or near there.


