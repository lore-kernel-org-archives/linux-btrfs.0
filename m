Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50175 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2J1Jiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 05:38:52 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so3849840oag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 02:38:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52C8A7E3-239C-45C8-BB50-D66F4C2312D7@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan>
	<64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com>
	<CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com>
	<B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com>
	<CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com>
	<CAG1y0seHi9G79XxHqb7XzUFPbOyPX=ft_CNzC+HMS8S87LSCPQ@mail.gmail.com>
	<52C8A7E3-239C-45C8-BB50-D66F4C2312D7@colorremedies.com>
Date: Sun, 28 Oct 2012 16:38:51 +0700
Message-ID: <CAG1y0sddcLux_KQtCQh02wi-i296mY8PC8Y7BdwC4h1rZzpqBQ@mail.gmail.com>
Subject: Re: Naming of (bootable) subvolumes
From: "Fajar A. Nugraha" <list@fajar.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 28, 2012 at 12:22 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Oct 26, 2012, at 9:03 PM, Fajar A. Nugraha <list@fajar.net> wrote:
>
>>
>> So back to the original question, I'd suggest NOT to use either
>> send/receive or set-default. Instead, setup multiple boot environment
>> (e.g. old version, current version) and let user choose which one to
>> boot using a menu.
>
> Is it possible to make a functioning symbolic or hard link of a subvolume?
>

Nope, I don't think so.

> I'm fine with "current" and "previous" options. More than that seems unnecessary. But then, how does the user choose?

WIth up and down arrow :)

> What's the UI?

Grub boot menu.

> Is this properly the domain of GRUB2 or something else?

In my setup I use grub2's "configfile" ability. Which basically does a
"go evaluate this other menu config file".

Each boot environment (BE, the term that solaris uses) has a different
entry on the "main" grub.cfg, which loads the BE's corresponding
grub.cfg.

>
> On BIOS machines, perhaps GRUB. On UEFI, I'd say distinctly not GRUB (I think it's a distinctly bad idea to have a combined boot manager and bootloader in a UEFI context, but that's a separate debate).

I don't use UEFI. But the general idea is to have one bootloader which
can load additional config files. And the location of that additional
config file depends on which BE user wants to boot.

> On this system, grub-mkconfig produces a grub.cfg only for the system I'm currently booted from. It does not include any entries for fedora18/boot, fedora18/root, even though they are well within the normal search path. And the reference used is relative,  i.e. the kernel parameter in the grub.cfg is rootflags=subvol=root
>
> If it were to create entries potentially for every snapshotted system, it would be a very messy grub.cfg indeed.
>
> It stands to reason that each distro will continue to have their own grub.cfg.
>

No arguments there. Even in my setup, when I run "update-grub", it
will only update its own grub.cfg, and leave the "main" grub.cfg
untouched. This is how my "main" grub.cfg looks like:


#===========================
set timeout=2

menuentry 'Ubuntu - 20120905 boot menu' {
	configfile	/ROOT/precise-5/@/boot/grub/grub.cfg
}
menuentry 'Ubuntu - 20120814 boot menu' {
	configfile	/ROOT/precise-4/@/boot/grub/grub.cfg
}
#===========================

each BE's grub cfg (e.g. the one under ROOT/precise-5 dataset) is just
your typical Ubuntu's grub.cfg, with only references to kernel/initrd
under that dataser.

> For BIOS machines, it could be useful if a single core.img containing a single standardized prefix specifying a grub location could be agreed upon. And then merely changing the set-default subvolume would allow different distro grub.cfg's to be found, read and workable with the relative references now in place, (except for home which likely needs to be mounted using subvolid).

IMHO the biggest difference is that grub support for zfsonlinux, even
though it has bootfs pool property, has a way to reference ALL
versions of a file (including grub.cfg/kernel/initrd) during boot
time. This way you don't even need to change bootfs whenever you want
to change to a boot environment, you simply choose (or write) a
different grub stanza to boot.

If we continue to rely on current btrfs grub support, unfortunately we
can't have the same thing. And the closest thing would be
"set-default". Which IMHO is VERY messy.

-- 
Fajar
