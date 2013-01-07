Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:37621
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755803Ab3AGWEf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 17:04:35 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /boot as a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50EB4111.4040904@czarc.net>
Date: Mon, 7 Jan 2013 15:04:32 -0700
Message-Id: <214AB2B0-BB24-41FC-BD34-D713130D4D2F@colorremedies.com>
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org> <50E9D909.1020207@czarc.net> <795F4F16-84AD-4815-9CCB-B3C34BD33BC6@colorremedies.com> <50EAECED.8060809@czarc.net> <31843ED0-51CB-4724-BEB1-5414F25386EC@colorremedies.com> <50EB4111.4040904@czarc.net>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 7, 2013, at 2:41 PM, Gene Czarcinski <gene@czarc.net> wrote:
>> 
>> And then if a distribution is deleted from the system, how is this discovered, and the old entry in the primary grub.cfg removed? Messy.
> The hardware systems have four or five software systems on each.  It is not so much of deleting an distribution as much as just ignoring it.  Disk space really is pretty inexpensive these days.

The case of natively booting/rebooting different OS's/distributions on BIOS is difficult. For VM, I think maybe a simpler approach like syslinux is better, which understands Btrfs I believe. And for UEFI, I think a simpler approach is something like rEFInd or gummiboot, as boot manager, and then for various linux distributions to be built with EFI_STUB.

>> 
>>> I do not actually use a grub partition but, instead, a minimal system with grub2 and installation into the MBR.
>> grub's core.img can accept a baked in grub.cfg
> If this was a true production situation then this would be a good choice but I am dealing with more of a laboratory environment with things that change a lot.

Yeah currently it's difficult to do multiple OS native booting.

Chris Murphy