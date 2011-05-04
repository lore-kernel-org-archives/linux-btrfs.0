From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Wed, 4 May 2011 09:44:20 +0700
Message-ID: <BANLkTinxyFTWAoZ+pTeQYqDjaLoFSueMnQ@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<BANLkTinPUPM6+iNUvYfx0_C-Wt32eb_1jQ@mail.gmail.com>
	<201105031520.49993.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105031520.49993.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2011 at 5:20 AM,  <CACook@quantum-sci.com> wrote:
> On Tuesday 3 May, 2011 14:26:52 Fajar A. Nugraha wrote:
>> Does Debian (or whatever distro you use) support BTRFS "/"?
>> If yes, you should ask them.
>
> What do you mean 'does Debian support BTRFS'? =A0The kernel supports =
it.

Just because you can use something doesn't mean it's supported by the d=
istro.

=46or example, RHEL6 marks btrfs as "technology preview", in other word=
s
"you can use it to try out new features but don't complain if
anything's broken". There should be a similar warning in Debian.

In your case, the "broken" part is the integration with other distro
components (e.g grub)

> And why would they know more about BTRFS than you?

A good distro would normally test all components included, and mark
them as supported or not. If it's not supported, then you should
expect lower level of funcionality or integration compared to
supported components. Some signs of unsupported components:
- it's marked as "technology preview" (like in RHEL6 case)
- kernel supports it, but the distro installer does not let you use it
by default (needs some manual setup of installer flags)
- it's on a different repository (like Ubuntu's universe/multiverse)
- it's not listed as supported component

Sometimes when a distro includes a technology preview, they'd also
include known issues, caveats, or workaround needed to make it work.
In Ubuntu maverick (I suspect it's also the same in Debian) you need
to manually update to newer version of grub-pc.

>
> My whole system is installed over BTRFS. =A0If this is non-functional=
 in any OS there should be a warning indicating it is non-functional.
>

There is, though the location and form may be distributed all over the =
place.

There's a warning in the kernel (see Chris's post)

Debian install manual
(http://www.debian.org/releases/stable/amd64/ch06s03.html.en#di-partiti=
on)
also doesn't list btrfs as supported partition type, in other words
it's unsupported.

>
>> Looks like grub problem. I know that Ubuntu Natty's grub-pc (grub2)
>> work just fine, so you might be able to fix it by upgrading to newer
>> grub/grub-pc (perhaps from Debian-unstable).
>
> I would be happy to upgrade grub, but the package management system i=
s jammed because of this.

You can download grub-related packages (should be grub and grub-pc,
possibly from Debian unstable) and install it manually using dpkg.

You might also need to temporarily rename /usr/sbin/update-grub
manually elsewhere and replace it with symlink to /bin/true, or move
/etc/kernel/postinst.d/zz-update-grub out of the way (just to enable
update process run correctly).

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
