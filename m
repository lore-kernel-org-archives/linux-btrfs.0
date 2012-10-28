Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:36969
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab2J1Q5E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 12:57:04 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Naming of (bootable) subvolumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <508CF9ED.5040806@inwind.it>
Date: Sun, 28 Oct 2012 10:57:03 -0600
Message-Id: <AD5641ED-562C-4DF6-AD39-6F461D81D3A3@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan> <64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com> <CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com> <B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com> <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com> <CAG1y0seHi9G79XxHqb7XzUFPbOyPX=ft_CNzC+HMS8S87LSCPQ@mail.gmail.com> <52C8A7E3-239C-45C8-BB50-D66F4C2312D7@colorremedies.com> <508CF9ED.5040806@inwind.it>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 28, 2012, at 3:25 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> On Sun, Oct 28, 2012 at 12:22 AM, Chris Murphy <lists@colorremedies.com> wrote:


> On my computer, when update-grub is called, it scans for all the
> subvolumes and show them in the menu, allowing the user to switch at
> boot time.

If they can go in a snapshots submenu, fine. But UI wise, messy and not inherently a good idea to expose to regular Joe user in the main menu. What's the kernel parameter rootflags= line they're using? Is it a subvol hard path or subvolid?

>> If it were to create entries potentially for every snapshotted
>> system, it would be a very messy grub.cfg indeed.
> 
> I don't think so. If a subvolume has a /sbin/int and and /etc it would
> be suitable to be used as root filesystem.

I understand it's suitable in that it will work. I'm just saying I don't want to see it by default in a menu. I do want to have to go dig for it, because most people most of the time won't have a need to use them. So in the main menu an option 'Snapshots' or 'Previous Systems' to reveal the snapshot list makes sense.


On Oct 28, 2012, at 3:38 AM, "Fajar A. Nugraha" <list@fajar.net> wrote:

>> What's the UI?
> 
> Grub boot menu.

If the UI for switching between subvols is via grub, that means no dependency on 'subvolume set-default'. While you can call the root subvolume absolutely with rootflags=subvol=/hardpath/here/ or rootflags=subvolid=, what about the boot subvol? That's always a relative path as far as I can tell.

So is the grub boot menu itself, i.e. t he grub.cfg that's used depends on the set-default. Are Ubuntu snapshots based just on snapshotting the root subvolume and keeping all possible kernels in a boot subvolume?

>> Is this properly the domain of GRUB2 or something else?
> 
> In my setup I use grub2's "configfile" ability. Which basically does a
> "go evaluate this other menu config file".

*sigh* two GRUB menus. Twice the pain, three times the mischief. But I understand how this works.

>> On BIOS machines, perhaps GRUB. On UEFI, I'd say distinctly not GRUB (I think it's a distinctly bad idea to have a combined boot manager and bootloader in a UEFI context, but that's a separate debate).
> 
> I don't use UEFI. But the general idea is to have one bootloader which
> can load additional config files. And the location of that additional
> config file depends on which BE user wants to boot.


Therein lies some confusion to answer the question of how to organize snapshots and boot from them. Various boot managers and boot loaders should be taken into account, and UEFI firmware implication should be taken into account as well.


> IMHO the biggest difference is that grub support for zfsonlinux, even
> though it has bootfs pool property, has a way to reference ALL
> versions of a file (including grub.cfg/kernel/initrd) during boot
> time. This way you don't even need to change bootfs whenever you want
> to change to a boot environment, you simply choose (or write) a
> different grub stanza to boot.
> 
> If we continue to rely on current btrfs grub support, unfortunately we
> can't have the same thing. And the closest thing would be
> "set-default". Which IMHO is VERY messy.

I'm not entirely familiar with how ZFS implements snapshots or grub's support for them. But it sonds like the bootfs pool property supports absolute path names everywhere, including from within the GRUB core.img? So you're suggesting a GRUB2 limitation when it comes to btrfs?

Fedora has also a limitation where kernel updates are still using grubby, not grub-mkconfig. That's also a problem IMO. It basically just takes the current entry and makes a kernel modification. If a snapshot is produced with each upgrade, the resulting grub.cfg will not be aware of or point to demoted kernels in snapshots. So if GRUB is a weak link for btrfs support, grubby is a weaker link.

Will btrfs send / receive for snapshotting produce large storage requirements isn't it? If I send a current subvol to another subvol as a snapshot, am I not effectively making a copy of that whole sub-filesystem? Whereas 'subvolume snapshot' just does this with metadata, no meaningful additional space required. Only the updated files consume more space, regardless of which snapshot they're applied to.



Chris Murphy

