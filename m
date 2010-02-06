From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: does btrfs have RAID I/O throughput (un)limiting sysctls, similar to
	md?
Date: Fri, 5 Feb 2010 16:37:24 -0800
Message-ID: <c67eed301002051637p1288e120tb37c649ac44d40c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

i've a 4 drive array connected via a PCIe SATA card.

per OS (opensuse) default, md RAID I/O performance was being limited by,

  cat /proc/sys/dev/raid/speed_limit_min
    1000
  cat /proc/sys/dev/raid/speed_limit_max
    200000

changing,

  echo "dev.raid.speed_limit_min=100000" >> /etc/sysctl.conf
  echo "dev.raid.speed_limit_max=600000" >> /etc/sysctl.conf

enabled full/best I/O throughput.

does btrfs have a similar construct that I need to set/tweak for
maximum I/O throughput?
