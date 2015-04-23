Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:59839 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966377AbbDWRMv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 13:12:51 -0400
Date: Thu, 23 Apr 2015 19:12:48 +0200
From: Lennart Poettering <lennart@poettering.net>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
Message-ID: <20150423171248.GD29642@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
 <20150423115056.GA28566@gardel-login>
 <CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
 <20150423144708.GB29079@gardel-login>
 <CAK1hC9s9DQaL8-E4_R-4pr-iC0K93D+6Yf-nqqsUsNtfrr74eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK1hC9s9DQaL8-E4_R-4pr-iC0K93D+6Yf-nqqsUsNtfrr74eQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23.04.15 19:00, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:

> On Thu, Apr 23, 2015 at 4:47 PM, Lennart Poettering
> <lennart@poettering.net> wrote:
> > On Thu, 23.04.15 14:18, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:
> >
> >> > Pick one:
> >> >
> >> > a) download the raw image and use that, but it will be a loopback file
> >> > with its own file system inside
> >> >
> >> > or:
> >> >
> >> > b) do the dnf/yum install root thing, and install it into a directory
> >> > tree.
> >>
> >> I installed yum package on Arch but couldn't manage to do the install.
> >>
> >> # yum -y --releasever=22 --nogpg --installroot=/var/lib/machines/enl
> >> --disablerepo='*' --enablerepo=fedora install systemd passwd dnf
> >> fedora-release-server
> >> Error getting repository data for fedora, repository not found
> >> # yum repolist all
> >> repolist: 0
> >>
> >> In fact, /etc/yum/repos.d is empty, so I am not surprised.
> >
> > Of course, you could use the .raw image, mount the extern btrfs volume
> > into it via nspawn's --bind= switch, then use yum inside of that
> > container to install into the btrfs volume. Then get rid of the .raw
> > image again, and you still have the btrfs volume that should be
> > bootable.
> >
> > A bit complex, but you almost were there already... ;-)
> 
> Wunderbach
> 
> # systemd-nspawn -M Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw --
> bind=/var/lib/machines/enl:/mnt
> [root@Fedora-Cloud-Base-22_Beta-20150415 ~]#dnf -y --releasever=22
> --nogpg --installroot=/mnt
>  --disablerepo='*' --enablerepo=fedora install systemd passwd dnf
> ................
> Complete!
> 
> -------------------------------------------------------------------------
> $ ls /var/lib/machines/enl
> boot/  etc/   media/  opt/   root/  srv/  tmp/  var/  lib@    sbin@
> dev/   home/  mnt/    proc/  run/   sys/  usr/  bin@  lib64@
> -------------------------------------------------------------------------------------
> 
> But now booting but hanging:
> 
> #systemd-nspawn -bD /var/lib/machines/enl
> Spawning container enl on /var/lib/machines/enl.
> Press ^] three times within 1s to kill container.
> systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA
> -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL
> +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
> Detected virtualization 'systemd-nspawn'.
> Detected architecture 'x86-64'.
> Running with unpopulated /etc.
> 
> Welcome to Fedora 22 (Twenty Two)!
> 
> Initializing machine ID from random generator.
> Populated /etc with preset unit settings.
> Unit etc.mount is bound to inactive unit dev-sdb1.device. Stopping, too.
> Unit var.mount is bound to inactive unit dev-sdb1.device. Stopping, too.
> Cannot add dependency job for unit display-manager.service, ignoring:
> Unit display-manager.service failed to load: No such file or
> directory.
> Startup finished in 51ms.
> 
> ------------------------------------------------------------------------
> 
> Maybe my btrfs story ?
> > Unit etc.mount is bound to inactive unit dev-sdb1.device. Stopping, too.
> > Unit var.mount is bound to inactive unit dev-sdb1.device. Stopping, too.
> Will investigate.
> 
> --bind was certainly the most easy trick once the raw image is downloaded.

Hmm, my guess is that you somehow lost the /etc and /var directories
half way, probably because of the weird mounting your are
doing. --bind= should normally be recursive, but maybe this didn't work?

Lennart

-- 
Lennart Poettering, Red Hat
