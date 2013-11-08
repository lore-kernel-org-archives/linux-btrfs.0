Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:55517 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab3KHThk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 14:37:40 -0500
Date: Fri, 08 Nov 2013 20:37:37 +0100
From: yzb3@wp.pl
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Odp: Re: Odp: Btrfs might be gradually slowing the boot process
Message-ID: <527d3d814dcdb2.95923869@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sure;

the kernel line from grub.cfg:
linux   /boot/vmlinuz-linux root=UUID=c26e6d9a-0bbb-436a-a217-95c738b5b9c6 rootflags=noatime,space_cache rw quiet

proc/mounts:
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sys /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
dev /dev devtmpfs rw,nosuid,relatime,size=4028896k,nr_inodes=1007224,mode=755 0 0
run /run tmpfs rw,nosuid,nodev,relatime,mode=755 0 0
/dev/sda2 / btrfs rw,noatime,space_cache 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
cgroup /sys/fs/cgroup/net_cls cgroup rw,nosuid,nodev,noexec,relatime,net_cls 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=33,pgrp=1,timeout=300,minproto=5,maxproto=5,direct 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
tmpfs /tmp tmpfs rw 0 0
/dev/sda2 /home btrfs rw,relatime,space_cache 0 0


