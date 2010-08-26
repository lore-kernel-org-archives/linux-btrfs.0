From: Diego Calleja <diegocg@gmail.com>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Fri, 27 Aug 2010 01:17:06 +0200
Message-ID: <201008270117.06249.diegocg@gmail.com>
References: <31081717.109.1282862751167.JavaMail.root@zimbra>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: "Morten P.D. Stevens" <mstevens@imt-systems.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, Chris Ball <cjb@laptop.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <31081717.109.1282862751167.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

> Even with cheap drives, a filesystem shouldn't die. With stuff like ZFS, you can use all sorts of crap and still live with it. Btrfs should follow that track.


Sadly that's not true, a bit of cooperation of the hardware is needed.
Both Btrfs and ZFS need to be sure that certain operations i.e. writting
a modified superblock need to be physically on the disk. Some disks lie
(or fail) when they are asked to write data to the disk, and both filesystems
have faced filesystem inconsistencies due to this. AFAIK there is nothing
the filesystem can do to avoid that.
