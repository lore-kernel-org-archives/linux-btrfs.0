From: Sander <sander@humilis.net>
Subject: Offtopic: Which SAS / SATA HBA do you recommend?
Date: Mon, 20 Jul 2009 11:28:38 +0200
Message-ID: <20090720092838.GA1375@cumulus>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Sorry for the offtopic question. I hope though that others on this list
or reading the archive find the answers useful too.

It seems the Adaptec 1405 4port SAS HBA I bought only works with RHEL
and SuSE through a closed source driver, and thus is quite useless :-(
I was stupid enought to think "Works with RHEL and SuSE" meant "Certified
for RHEL and SuSE, but driver in mainstream kernel" ..

What SAS (or SATA) controller do you use or recommend in combination
with a SSD and BTRFS?

I'm looking for a non-RAID controller with four or eight ports and of
course full Linux support.

Currently I have a 8x 2.5" SAS/SATA chassis and two Intel X25-E 64GB
drivers which will have a BTRFS RAID0 filesystem.

I already have a Marvell MV88SX6081 eight port SATA controller, but it
has no free ports and is pretty old.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
