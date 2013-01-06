Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:47442 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3AFUFb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 15:05:31 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130106200530.NNN6475.eastrmfepo202.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 15:05:30 -0500
Message-ID: <50E9D909.1020207@czarc.net>
Date: Sun, 06 Jan 2013 15:05:29 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org>
In-Reply-To: <50E9CDB3.3010401@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2013 02:17 PM, Swâmi Petaramesh wrote:
> Le 06/01/2013 20:11, Chris Murphy a écrit :
>> If you use UUID, and you use subvol=, and you don't rename/move your subvolume, it's perfectly safe. Nevertheless, GRUB becoming subvolid aware seems like a good idea to me, but I have no idea what's involved in that.
> I actually run several machines on which I have /boot in a separate
> BTRFS subvol, without any issue. I have a multiboot between several
> different distros (typically Ubuntu, Mint, LMDE, Bodhi... All Ubuntu
> derivatives except for LMDE which is Debian-based...) sharing the same
> BTRFS container and using different subvols i.e. UBUNTU/@boot,
> LMDE/@boot etc...
>
> Works just great.
>
I assume you have a "grub partition" (or its equivalent) with a grub.cfg 
file having menuentry definitions [pointing to the different grub.cfg 
file for each system ... that seems to work well (at least for me).  
Currently, os-prober does not support btrfs.

I have taken a little look at the grub2 source code and there is some 
mention of both btrfs and zfs (and also btrfs subvolumes) in the 
changelogs.  However, it is not clear to me (and I have not had the time 
yet) to explore exactly what the source code is doing or not doing.

Gene
