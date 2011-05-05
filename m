From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 13:28:19 -0600
Message-ID: <BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105031520.49993.CACook@quantum-sci.com>
	<20110504095153.GA6914@attic.humilis.net>
	<201105050749.09690.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105050749.09690.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 8:49 AM,  <CACook@quantum-sci.com> wrote:
> On Wednesday 4 May, 2011 02:51:54 Sander wrote:
>> Put an exit on top of /etc/kernel/postrm.d/zz-update-grub and try ag=
ain.
>>
>> Install grub-pc 1.99~rc1-13 from Sid.
>
> First I put an exit right after #! /bin/sh =C2=A0and it failed. =C2=A0=
Then I moved /etc/kernel/postrm.d/zz-update-grub to / and it still fail=
ed.
>
> Grub is not running as a daemon, so I shouldn't have to reboot for th=
e new version to take effect. =C2=A0And frankly at the moment I'm afrai=
d to reboot, with only grub-common installed.
>
> # dpkg -i /var/cache/apt/archives/grub-common_1.99~rc1-13_amd64.deb
> (Reading database ... 136689 files and directories currently installe=
d.)
> Preparing to replace grub-common 1.98+20100804-14 (using .../grub-com=
mon_1.99~rc1-13_amd64.deb) ...
> Unpacking replacement grub-common ...
> Setting up grub-common (1.99~rc1-13) ...
> Installing new version of config file /etc/grub.d/10_linux ...
> Installing new version of config file /etc/grub.d/30_os-prober ...
> Installing new version of config file /etc/grub.d/00_header ...
> Installing new version of config file /etc/grub.d/20_linux_xen ...
> Processing triggers for install-info ...
> Processing triggers for man-db ...
>
> # dpkg -i /var/cache/apt/archives/grub-pc_1.99~rc1-13_amd64.deb
> (Reading database ... 136703 files and directories currently installe=
d.)
> Preparing to replace grub-pc 1.99~rc1-13 (using .../grub-pc_1.99~rc1-=
13_amd64.deb) ...
> Unpacking replacement grub-pc ...
> Setting up grub-pc (1.99~rc1-13) ...
> grub-probe: error: cannot stat `/dev/root'.
> Installation finished. No error reported.
> /usr/sbin/grub-probe: error: cannot stat `/dev/root'.
> dpkg: error processing grub-pc (--install):
> =C2=A0subprocess installed post-installation script returned error ex=
it status 1
> Processing triggers for man-db ...
> Errors were encountered while processing:
> =C2=A0grub-pc
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

You'll need to contact somebody more familiar with debian, as this
isn't really a btrfs issue.

Yes, btrfs is the obvious cause, but it's grub's handling of it that
is the problem, and dpkg's handling of grub's failure that is really
blocking you.

This is what it meant by "does debian support btrfs?".  It's not a
question of whether btrfs is in debian's kernel, but whether all the
pieces of debian which are directly or indirectly affected by btrfs
are known to work right, and whether they're currently willing to
spend effort on these issues.

If they're not currently providing that level of support, then it's
completely up to you to have a good understanding of how the rest of
debian is put together so that you yourself can make things works.

As was mentioned previously, there is an updated grub package, so your
main objective is to find out from debian how to disable or override
the failing package long enough to install the replacement.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
