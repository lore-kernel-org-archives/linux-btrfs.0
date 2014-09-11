Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48490 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaIKJ43 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 05:56:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XS175-0000zR-36
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 11:56:27 +0200
Received: from host86-174-242-234.range86-174.btcentralplus.com ([86.174.242.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 11:56:27 +0200
Received: from linux by host86-174-242-234.range86-174.btcentralplus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 11:56:27 +0200
To: linux-btrfs@vger.kernel.org
From: Bob Williams <linux@barrowhillfarm.org.uk>
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Date: Thu, 11 Sep 2014 10:56:14 +0100
Message-ID: <lurrju$n90$1@ger.gmane.org>
References: <541043B8.7010601@barrowhillfarm.org.uk> <54109BCD.5000106@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54109BCD.5000106@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/09/14 19:43, Goffredo Baroncelli wrote:
> On 09/10/2014 02:27 PM, Bob Williams wrote:
>> I have two 2TB disks formatted as a btrfs raid1 array, mirroring both
>> data and metadata. Last night I started
>>
>> # btrfs filesystem balance <path>
> 
> 
> May be that I am missing something obvious, however I have to ask which 
> would be the purpose to balance a two disks RAID1 system.
> The balance command should move the data between the disks in order to
> avoid some disk full and other empty; but this assume that there is a
> not symmetrical uses of the disks. Which is not the case for a RAID1/two
> disks system.
> 
> If the disk were more than two the situation would be completely different.
> But Bob reports that the system is compose by two disks only.
> 
>>
>> and it is still running 18 hours later. This suggests that most stuff
>> only gets written to one physical device, which in turn suggests that
>> there is a risk of lost data if one physical device fails. Or is
>> there something clever about btrfs raid that I've missed? I've used
>> linux software raid (mdraid) before, and it appeared to write to both
>> devices simultaneously.
>>

So if a RAID1/two disk system uses the disks symmetrically, why did my
balance command take 22 hours? That's what puzzles me, as my
understanding of RAID1 is that the disk use *is* symmetrical.

Bob




