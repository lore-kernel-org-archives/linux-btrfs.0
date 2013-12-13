Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37635 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3LMLJI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 06:09:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VrQcF-0001qo-54
	for linux-btrfs@vger.kernel.org; Fri, 13 Dec 2013 12:09:07 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 12:09:07 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 12:09:07 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs raid multiple devices IO utilisation
Date: Fri, 13 Dec 2013 11:08:56 +0000
Message-ID: <l8eprt$u46$1@ger.gmane.org>
References: <l8ce99$31i$1@ger.gmane.org> <pan$46d7a$8ee1d67e$83395712$322d43d@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$46d7a$8ee1d67e$83395712$322d43d@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/12/13 09:13, Duncan wrote:
> Martin posted on Thu, 12 Dec 2013 13:39:00 +0000 as excerpted:
> 
>> Some time back, I noticed that with a two HDD btrfs raid1, some tasks
>> suffered ALL the IO getting choked onto just one HDD!
>>
>> That turned out to be a feature of the btrfs code whereby a device is
>> chosen depending on the process ID. For some cases such as in a bash
>> loop, the PID increments by two for each iteration and so only one HDD
>> ever gets hit...
> 
> Unfortunately, yes...


> ... Of course that's if the queue 
> length is reasonably accessible to btrfs, as you already asked in the bit 
> I snipped as out of my knowledgeable reply range.

And that's the bit that is outside of my knowledge... Hence the question.

Here's hoping someone can give a pointer before I need to delve into
other code such as for 'atop' to see how it is done there if I'm to take
a stab at it.

Or if someone is already coding something up, please let us know?


Or:

>From within btrfs code, is there an easy/fast/any way to check the IO
queue length for whatever btrfs target device?

Regards,
Martin



