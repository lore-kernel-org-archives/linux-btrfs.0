Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:56753
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756084Ab3AFTLq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Jan 2013 14:11:46 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /boot as a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50E98DC6.3030304@czarc.net>
Date: Sun, 6 Jan 2013 12:11:46 -0700
Cc: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Message-Id: <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com>
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net>
To: Gene Czarcinski <gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 6, 2013, at 7:44 AM, Gene Czarcinski <gene@czarc.net> wrote:

> On 01/05/2013 04:27 PM, Chris Murphy wrote:
>> On Jan 5, 2013, at 2:17 PM, Gene Czarcinski <gene@czarc.net> wrote:
>> 
>>> As of the latest updates to anaconda and grub2 for Fedora 18, it is now possible to install with /boot as a btrfs subvolume.  The way that grub2 is handling this is the "reach down" to the files it needs as if the subvolume was a directory.
>>> 
>>> Is this OK?
>> Mostly, but getting GRUB2 to handle subvolid I think would be better, because then subvols can be moved/renamed and things still would work.
>> 
>> Small problem currently is Fedora 18 still depends on grubby to make grub.cfg changes, and grubby is being kinda dumb about updating grub.cfg when /boot is on a boot subvol - ergo there's an error and it doesn't update the grub.cfg correctly.
>> https://bugzilla.redhat.com/show_bug.cgi?id=864198
>> Work around after any kernel update is to run grub2-mkconfig -o /boot/grub2/grub.cfg manually, and then the grub.cfg is correct.
>> 
>>> At this point I am not worried about snapshots or any other complexities.  If the subvolume name is known. should grub2 be able to reliably "reach down" as if that subvolume was a directory?  It needs some of its configuration files and, of course, the linux kernel.
>> It's two parts. GRUB's core.img code works as you describe. But grub-install and grub-mkconfig depend on /etc/fstab. If I use subvolid= in /etc/fstab and update either core.img or grub.cfg (with -install or -mkconfig), then the system is no longer bootable.
> So, I conclude from the above that the "safe" thing to do is to keep /boot as a separate ext2/3/4 partition.


It depends on what you're comparing. And also what you mean by "not safe".

fstab using labels with ext[234] could see a conflict one day, just the same as possibly renaming/moving a Btrfs subvolume used for boot, or even root for that matter.

If you use UUID, and you use subvol=, and you don't rename/move your subvolume, it's perfectly safe. Nevertheless, GRUB becoming subvolid aware seems like a good idea to me, but I have no idea what's involved in that.

Chris Murphy