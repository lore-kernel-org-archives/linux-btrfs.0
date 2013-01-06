Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:57716 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab3AFOoX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 09:44:23 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130106144423.LZPE6475.eastrmfepo202.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 09:44:23 -0500
Message-ID: <50E98DC6.3030304@czarc.net>
Date: Sun, 06 Jan 2013 09:44:22 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com>
In-Reply-To: <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2013 04:27 PM, Chris Murphy wrote:
> On Jan 5, 2013, at 2:17 PM, Gene Czarcinski <gene@czarc.net> wrote:
>
>> As of the latest updates to anaconda and grub2 for Fedora 18, it is now possible to install with /boot as a btrfs subvolume.  The way that grub2 is handling this is the "reach down" to the files it needs as if the subvolume was a directory.
>>
>> Is this OK?
> Mostly, but getting GRUB2 to handle subvolid I think would be better, because then subvols can be moved/renamed and things still would work.
>
> Small problem currently is Fedora 18 still depends on grubby to make grub.cfg changes, and grubby is being kinda dumb about updating grub.cfg when /boot is on a boot subvol - ergo there's an error and it doesn't update the grub.cfg correctly.
> https://bugzilla.redhat.com/show_bug.cgi?id=864198
> Work around after any kernel update is to run grub2-mkconfig -o /boot/grub2/grub.cfg manually, and then the grub.cfg is correct.
>
>> At this point I am not worried about snapshots or any other complexities.  If the subvolume name is known. should grub2 be able to reliably "reach down" as if that subvolume was a directory?  It needs some of its configuration files and, of course, the linux kernel.
> It's two parts. GRUB's core.img code works as you describe. But grub-install and grub-mkconfig depend on /etc/fstab. If I use subvolid= in /etc/fstab and update either core.img or grub.cfg (with -install or -mkconfig), then the system is no longer bootable.
So, I conclude from the above that the "safe" thing to do is to keep 
/boot as a separate ext2/3/4 partition.

Gene
