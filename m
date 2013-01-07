Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:41891 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab3AGCAx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Jan 2013 21:00:53 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /boot as a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50E9D909.1020207@czarc.net>
Date: Sun, 6 Jan 2013 19:00:49 -0700
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Message-Id: <795F4F16-84AD-4815-9CCB-B3C34BD33BC6@colorremedies.com>
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org> <50E9D909.1020207@czarc.net>
To: Gene Czarcinski <gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 6, 2013, at 1:05 PM, Gene Czarcinski <gene@czarc.net> wrote:

> On 01/06/2013 02:17 PM, Swâmi Petaramesh wrote:
>> Le 06/01/2013 20:11, Chris Murphy a écrit :
>>> If you use UUID, and you use subvol=, and you don't rename/move your subvolume, it's perfectly safe. Nevertheless, GRUB becoming subvolid aware seems like a good idea to me, but I have no idea what's involved in that.
>> I actually run several machines on which I have /boot in a separate
>> BTRFS subvol, without any issue. I have a multiboot between several
>> different distros (typically Ubuntu, Mint, LMDE, Bodhi... All Ubuntu
>> derivatives except for LMDE which is Debian-based...) sharing the same
>> BTRFS container and using different subvols i.e. UBUNTU/@boot,
>> LMDE/@boot etc...
>> 
>> Works just great.
>> 
> I assume you have a "grub partition" (or its equivalent) with a grub.cfg file having menuentry definitions [pointing to the different grub.cfg file for each system ... that seems to work well (at least for me).  Currently, os-prober does not support btrfs.
> 
> I have taken a little look at the grub2 source code and there is some mention of both btrfs and zfs (and also btrfs subvolumes) in the changelogs.  However, it is not clear to me (and I have not had the time yet) to explore exactly what the source code is doing or not doing.

Well, at least with the f18 version of GRUB 2 2.00, whether alternative Btrfs bootable systems are mounted or not, -mkconfig isn't searching/finding for the /etc/fstab and /etc/default/grub of the other system like it appears to do with other file systems. I don't get any additional entries other than the currently booted Btrfs system.

So it looks like I'd need to manually add a configfile menu entry, pointing to each Btrfs bootable system. Chainloading from one grub to another is not useful. Better if they're all on the same GRUB, and use configfile.


Chris Murphy