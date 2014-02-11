Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43060 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566AbaBKRdk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 12:33:40 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: UEFI/BIOS, was: BTRFS with RAID1 cannot boot when removing drive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
Date: Tue, 11 Feb 2014 10:33:36 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <566EB7E3-55A0-48BA-95E7-573307D19705@colorremedies.com>
References: <20140209224055.3175e70f@system> <191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com> <20140211041527.57ef96c4@system> <pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 10, 2014, at 11:59 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Saint Germain posted on Tue, 11 Feb 2014 04:15:27 +0100 as excerpted:
> 
>> Ok I need to really understand how my motherboard works (new Z87E-ITX).
>> It is written "64Mb AMI UEFI Legal BIOS", so I thought it was really
>> UEFI.
> 
> I expect it's truly UEFI.  But from what I've read most UEFI based 
> firmware(possibly all in theory, with the caveat that there's bugs and 
> some might not actually work as intended due to bugs) on x86/amd64 (as 
> opposed to arm) has a legacy-BIOS mode fallback.  Provided it's not in 
> secure-boot mode, if the storage devices it is presented don't have a 
> valid UEFI config, it'll fall back to legacy-BIOS mode and try to detect 
> and boot that.

There are UEFI implementations that behave this way with respect to removable and optical devices, they'll try to boot UEFI mode first, and then fallback to BIOS. I've yet to find one that does this for a HDD although maybe it exists. What I've seen is the NVRAM has a boot option that expressly calls for booting a particular device with CSM-BIOS mode boot, or the user has to go into firmware setup and enable the CSM which does so for all boots. This option is sometimes hideously labeled as "disable UEFI". There are some (probably rare) UEFI firmware implementations without a CSM, the only two I can think of off hand are Itanium computers, and Apple's intel rack servers (since discontinued). But CSM isn't a UEFI requirement so there may be other cases where manufacturers have decided to go with only EFI or BIOS.

Chris Murphy

