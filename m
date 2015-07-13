Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:28710 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbGMMye (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 08:54:34 -0400
Message-ID: <55A3B508.7070500@profihost.ag>
Date: Mon, 13 Jul 2015 14:54:32 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: slowdown after one week
References: <55A0BBD7.5000400@profihost.ag> <55A39F10.5040304@gmail.com>
In-Reply-To: <55A39F10.5040304@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 13.07.2015 um 13:20 schrieb Austin S Hemmelgarn:
> On 2015-07-11 02:46, Stefan Priebe wrote:
>> Hi,
>>
>> while using a 40TB btrfs partition for VM backups. I see a massive
>> slowdown after around one week.
>>
>> The backup task takes usally 2-3 hours. After one week it takes 20
>> hours. If i umount and remount the btrfs volume it takes 2-3 hours again.
>>
>> Kernel 4.1.1
>>
> I've been seeing similar (although much less drastic) slowdowns over
> time myself pretty much since I started using BTRFS (IIRC, sometime
> around 3.16).  If you're not constantly writing to that backup volume,
> you might want to consider setting up automounting for it.
> 

Yes but that's awful. it's a bug. It would be very nice if someone
involved in the btrfs development can comment on that one.
