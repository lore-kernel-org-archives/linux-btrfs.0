Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32907 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbbD0OKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 10:10:07 -0400
Received: by lbbzk7 with SMTP id zk7so83113694lbb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 07:10:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK1hC9uX3iy=By2pXa5dPKJQTU7795Et78cD7_sQbLmv4LAc_w@mail.gmail.com>
References: <CAK1hC9uX3iy=By2pXa5dPKJQTU7795Et78cD7_sQbLmv4LAc_w@mail.gmail.com>
Date: Mon, 27 Apr 2015 16:10:05 +0200
Message-ID: <CAK1hC9tzAHoD3pxBSFjgyfivVsdAgoz19VA7S3oEnP30BP8Jiw@mail.gmail.com>
Subject: Re: installation of a nspwan-container on btrfs subvolumes
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 24, 2015 at 7:22 PM, arnaud gaboury
<arnaud.gaboury@gmail.com> wrote:
> Archlinux host
>
> 1- created 3 btrfs subvol on /dev/sdb1 (SSD). The goal is to manage
> snapshots easily.
> no nested subvol.
> ------------------------------------------
> # btrfs subvolume list .
> ID 266 gen 39 top level 5 path rootvol
> ID 268 gen 41 top level 5 path var
> ID 269 gen 42 top level 5 path etc
> ----------------------------------------------------
>
> 2 - mount btrfs subvol
> -------------------------------------------------------------------
> # mount -t btrfs -o subvol=rootvol /dev/sdb1 /var/lib/machines/poppy
> # mkdir /var/lib/machines/poppy/var
> # mkdir /var/lib/machines/poppy/etc
> # mount -t btrfs -o subvol=etc /dev/sdb1 /var/lib/machines/poppy/etc
> # mount -t btrfs -o subvol=var /dev/sdb1 /var/lib/machines/poppy/var
> --------------------------------------------------------------------
>
> 3- installed Fedora on /var/lib/machines/poppy
>
> 4- when booting the container, it hangs.
>
> weird:
> -------------------------------------------------------------------------------
> root@hortensia ➤➤ lib/machines # ls poppy/etc
> lvm/    systemd/  group    ld.so.cache  machine-id     os-release@  resolv.conf
> pam.d/  udev/     gshadow  localtime@   nsswitch.conf  passwd       shadow
> root@hortensia ➤➤ lib/machines # ls poppy/var
> cache/  lib/  log/  spool/  tmp/  lock@  run@
> --------------------------------------------------------------------------
> These above directories seems indeed quite empty
>
>
> Now:
> ----------------------------------------------------------------------------------------------------------------
> root@hortensia ➤➤ lib/machines # umount /var/lib/machines/poppy/etc
> root@hortensia ➤➤ lib/machines # umount /var/lib/machines/poppy/var
> root@hortensia ➤➤ lib/machines # ls poppy/var
> adm/    db/     games/   kerberos/  local/  nis/  preserve/  tmp/  lock@  run@
> cache/  empty/  gopher/  lib/       log/    opt/  spool/     yp/   mail@
> root@hortensia ➤➤ lib/machines # ls poppy/etc
> alternatives/       modules-load.d/  tmpfiles.d/              gshadow
>           passwd
> avahi/              NetworkManager/  udev/                    gshadow-
>           passwd-
> bash_completion.d/  openldap/        udisks2/
> host.conf          printcap
> binfmt.d/           opt/             X11/                     hosts
>           profile
> chkconfig.d/        pam.d/           xdg/
> hosts.allow        protocols
> cockpit/            pkcs11/          xinetd.d/
> hosts.deny         rc0.d@
> cron.d/             pki/             yum/                     init.d@
>           rc1.d@
> crypto-policies/    pm/              yum.repos.d/             inittab
>           rc2.d@
> dbus-1/             polkit-1/        adjtime                  inputrc
>           rc3.d@
> default/            popt.d/          aliases                  issue
>           rc4.d@
> depmod.d/           ppp/             bashrc
> issue.net          rc5.d@
> dhcp/               profile.d/       csh.cshrc
> krb5.conf          rc6.d@
> dnf/                rc.d/            csh.login
> ld.so.cache        redhat-release@
> dnsmasq.d/          rolekit/         DIR_COLORS
> ld.so.conf         resolv.conf
> docker/             rpm/             DIR_COLORS.256color
> libaudit.conf      rpc
> firewalld/          rwtab.d/         DIR_COLORS.lightbgcolor
> libuser.conf       rwtab
> gcrypt/             sasl2/           dnsmasq.conf
> localtime@         services
> gnupg/              security/        e2fsck.conf
> login.defs         shadow
> gss/                selinux/         environment
> machine-id         shadow-
> iproute2/           skel/            ethertypes
> mke2fs.conf        shells
> ld.so.conf.d/       ssl/             exports                  motd
>           statetab
> libnl/              statetab.d/      fedora-release           mtab@
>           sysctl.conf
> libreport/          sysconfig/       filesystems              networks
>           system-release@
> logrotate.d/        sysctl.d/        GREP_COLORS
> nsswitch.conf      system-release-cpe
> lvm/                systemd/         group
> nsswitch.conf.bak  tcsd.conf
> modprobe.d/         terminfo/        group-
> os-release@        xattr.conf
> ----------------------------------------------------------------------------------------------------------
>
> and the container now boots perfect and I can log in.
>
> So I must not mount the /etc and /var subvolumes to be able to boot
> the containers.
> My two subvolumes have been indeed populated, but in a very very
> uncompleted way. Why?
>
> What did I wrong in my settings? I was waiting for /etc and /var
> subvolumes full with all the needed files. Were I wrong?
>
> TY for hints

This issue is now solved. The root was the fact that I installed
Fedora from the minimal raw image this way:

# systemd-nspawn -M Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw
--bind=/var/lib/machines/poppy:/mnt

So in that case, only /var/lib/machines/poppy was populated by the installation.


The solution was:
# systemd-nspawn -M Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw
--bind=/var/lib/machines/poppy:/mnt
--bind=/var/lib/machines/poppy/etc:/mnt/etc
--bind=/var/lib/machines/poppy/var:/mnt/var




-- 

google.com/+arnaudgabourygabx
