Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from crane.lixil.net ([71.19.157.101]:55707 "EHLO crane.lixil.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab3HXSCG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 14:02:06 -0400
Received: from webmail.lixil.net (crane.lixil.net [71.19.157.101])
	(Authenticated sender: mrjoel@lixil.net)
	by crane.lixil.net (Postfix) with ESMTPSA id AA8A8142D79
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 18:02:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 24 Aug 2013 12:02:03 -0600
From: Joel Johnson <mrjoel@lixil.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Help interpreting RAID1 space allocation
In-Reply-To: <093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net>
 <093e4c7d21b5e734c86fc4bb1703a69e@lixil.net>
Message-ID: <0e13ab74252d33d24ad58591b7b0f6fb@lixil.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-08-24 11:24, Joel Johnson wrote:
> Should I file a few bugs to capture the related issues? Here are the
> discrete issues that seem to be present from a user point of view:

After writing this, I figured I'd experiment with the current state and 
try to properly delete and add the sdd device. However, I was surprised 
to find that I'm not allowed to remove one of the two drives in a RAID1. 
Kernel message is "btrfs: unable to go below two devices on raid1" Not 
allowing it by default makes some sense, however a --force flag or 
something would be beneficial. I understand that the preferred method is 
to add the replacement device first and then delete the old one (or do a 
direct replace), however the system I'm using for testing only has three 
SATA ports, the first is used for the system drive, and the second and 
third have the two drives I'm using for my btrfs testing - I have no way 
to add a third drive for the filesystem before removing one first. This 
is still with the filesystem mounted with the degraded mount option set.

As it stands, I don't see how I can run btrfs reliably on this system 
since I now know I want to properly remove devices and add them, but I'm 
unable to do so with the limited number of drive interfaces, requiring 
hot removal of drive, and either readding it, or using another system to 
clear the drive before readding it.

Is there a flag I'm missing? If not, I'd add a fourth bug item:

4. allow (forced only if appropriate) removal of redundant drives (e.g. 
second drive in RAID1)

Joel
