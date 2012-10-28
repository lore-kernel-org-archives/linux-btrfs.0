Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:36028 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2J1JY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 05:24:27 -0400
Message-ID: <508CF9ED.5040806@inwind.it>
Date: Sun, 28 Oct 2012 10:25:01 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Naming of (bootable) subvolumes
References: <1351168220.1923.6.camel@hughsie-work.lan> <64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com> <CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com> <B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com> <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com> <CAG1y0seHi9G79XxHqb7XzUFPbOyPX=ft_CNzC+HMS8S87LSCPQ@mail.gmail.com> <52C8A7E3-239C-45C8-BB50-D66F4C2312D7@colorremedies.com>
In-Reply-To: <52C8A7E3-239C-45C8-BB50-D66F4C2312D7@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-27 19:22, Chris Murphy wrote:
> 
> On Oct 26, 2012, at 9:03 PM, Fajar A. Nugraha <list@fajar.net>
> wrote:
> 
>> 
>> So back to the original question, I'd suggest NOT to use either 
>> send/receive or set-default. Instead, setup multiple boot
>> environment (e.g. old version, current version) and let user choose
>> which one to boot using a menu.
> 
> Is it possible to make a functioning symbolic or hard link of a
> subvolume?
> 
> I'm fine with "current" and "previous" options. More than that seems
> unnecessary. But then, how does the user choose? What's the UI? Is
> this properly the domain of GRUB2 or something else?


On my computer, when update-grub is called, it scans for all the
subvolumes and show them in the menu, allowing the user to switch at
boot time.

[...]
> 
> Example. The following are all subvolumes, subvolume set-default 0,
> fstab uses subvol=home, subvol=root, subvol=boot for mount options.
> 
> toplevel ├── boot ├── home ├── root ├── fedora18 │   ├── boot │   └──
> root
> 
> On this system, grub-mkconfig produces a grub.cfg only for the system
> I'm currently booted from. It does not include any entries for
> fedora18/boot, fedora18/root, even though they are well within the
> normal search path. And the reference used is relative,  i.e. the
> kernel parameter in the grub.cfg is rootflags=subvol=root
> 
> If it were to create entries potentially for every snapshotted
> system, it would be a very messy grub.cfg indeed.

I don't think so. If a subvolume has a /sbin/int and and /etc it would
be suitable to be used as root filesystem.

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
