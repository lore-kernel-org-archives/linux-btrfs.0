From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Wed, 4 May 2011 04:26:52 +0700
Message-ID: <BANLkTinPUPM6+iNUvYfx0_C-Wt32eb_1jQ@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105031227.43619.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2011 at 2:27 AM,  <CACook@quantum-sci.com> wrote:
>
> Having a failure that may be because grub2 doesn't BTRFS. =A0/boot is=
 ext3 and / is BTRFS.

Does Debian (or whatever distro you use) support BTRFS "/"?
If yes, you should ask them.
If no, then you should've already known that there's a risk when using
unsupported filesystem.

>
> # dpkg -r linux-image-2.6.32-5-amd64
> (Reading database ... 136673 files and directories currently installe=
d.)
> Removing linux-image-2.6.32-5-amd64 ...
> Examining /etc/kernel/postrm.d .
> run-parts: executing /etc/kernel/postrm.d/initramfs-tools 2.6.32-5-am=
d64 /boot/vmlinuz-2.6.32-5-amd64
> run-parts: executing /etc/kernel/postrm.d/zz-update-grub 2.6.32-5-amd=
64 /boot/vmlinuz-2.6.32-5-amd64
> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev moun=
ted?).
> run-parts: /etc/kernel/postrm.d/zz-update-grub exited with return cod=
e 1
> Failed to process /etc/kernel/postrm.d at /var/lib/dpkg/info/linux-im=
age-2.6.32-5-amd64.postrm line 234.
> dpkg: error processing linux-image-2.6.32-5-amd64 (--remove):
> =A0subprocess installed post-removal script returned error exit statu=
s 1
> Errors were encountered while processing:
> =A0linux-image-2.6.32-5-amd64

Looks like grub problem. I know that Ubuntu Natty's grub-pc (grub2)
work just fine, so you might be able to fix it by upgrading to newer
grub/grub-pc (perhaps from Debian-unstable).

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
