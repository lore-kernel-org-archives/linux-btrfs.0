Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35464 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3KHTqj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 14:46:39 -0500
Date: Fri, 8 Nov 2013 19:46:37 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: yzb3@wp.pl
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Odp: Re: Odp: Btrfs might be gradually slowing the boot process
Message-ID: <20131108194637.GT14405@carfax.org.uk>
References: <527d3d814dcdb2.95923869@wp.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1aBKeCoRrxtQ74y"
In-Reply-To: <527d3d814dcdb2.95923869@wp.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+1aBKeCoRrxtQ74y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 08, 2013 at 08:37:37PM +0100, yzb3@wp.pl wrote:
> Sure;
> 
> the kernel line from grub.cfg:
> linux   /boot/vmlinuz-linux root=UUID=c26e6d9a-0bbb-436a-a217-95c738b5b9c6 rootflags=noatime,space_cache rw quiet

   OK, this may be your problem. You're generating the space cache
every time you boot. You only need it once; let the disk activity on
boot finish (it may take a while, depending on how big your filesystem
is, and how much data it has, and how fragmented it is), and remove
the space_cache option from your rootflags. When you next boot, it
will use the existing cache rather than generating it again from
scratch.

   Hugo.

> proc/mounts:
> rootfs / rootfs rw 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> sys /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> dev /dev devtmpfs rw,nosuid,relatime,size=4028896k,nr_inodes=1007224,mode=755 0 0
> run /run tmpfs rw,nosuid,nodev,relatime,mode=755 0 0
> /dev/sda2 / btrfs rw,noatime,space_cache 0 0
> securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
> tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
> devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
> tmpfs /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,mode=755 0 0
> cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
> pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
> cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
> cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
> cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
> cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
> cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
> cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
> cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
> systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=33,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
> debugfs /sys/kernel/debug debugfs rw,relatime 0 0
> configfs /sys/kernel/config configfs rw,relatime 0 0
> mqueue /dev/mqueue mqueue rw,relatime 0 0
> hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
> tmpfs /tmp tmpfs rw 0 0
> /dev/sda2 /home btrfs rw,relatime,space_cache 0 0
> 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- People are too unreliable to be replaced by machines. ---      

--+1aBKeCoRrxtQ74y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUn0/nVheFHXiqx3kAQLrxw/9HOXEOlqGVfiXWoIzxvfn+WSmD6AhnzZv
ArdmPTuDAoHf2ZUiqqdo4wWh0iHQ/Ov8yLIGLLLKWEyQUxdQl4ZKJDYj4Z2VWViK
WKRpHU9ouyE/aaqyFYj49Vtoopcj2H+HDnMwBUR4LJ6k9jRqq79kl9UEQdVoYZev
2kPjR1UrfBaSCEWAakGDB3tuMKL4S8sUxyDtQMm/c9sHLm8rctXSGurQi+LJFI4o
xSjo1Lkjg6q2PS0QMc6eo0Xj41/cHKkdN1LvKjcfZ8AL0jOPruDtPYkoh5MpUdmO
J9VRPdSCpWfOu+ZVfaxAsyhJhKCtVwQX8PNnxCBeu0hsHCYfEB+FUoD2bsnWENyQ
1DqGJZlKga890U+8dfPGqal4q0TDxxTXqmY7RRmqVOstHATf45sFT5FK4vpwMpGY
Vp3C2vN5V0PetogNxUvQCELS7ykuVPhm90H0k17Sx91m9XuRx3VnS7Gex4BHTDel
hdPpHuCQT7XTAlACUiIknfmIZZchibXGIQC9tuycbDltD8/e/4f2Q7OYUqUL3x1s
ongucRHtIvLMBL28BeQdHZ0M2Hny3WJPdJxMw05MLwYFM2pfidMNalBn8jKtUS/W
KrsKbP4Z6BeeWPDSAdEQVBTRtD9rmEQFlxySplMlC+zU1GZmIuY8eaiB9Q2mZL/1
Rf+pwCDVMo4=
=nH2S
-----END PGP SIGNATURE-----

--+1aBKeCoRrxtQ74y--
