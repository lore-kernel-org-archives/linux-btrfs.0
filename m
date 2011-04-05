From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: files on not mounted subvolumes - mysql complains read only
Date: Wed, 6 Apr 2011 01:12:08 +0200
Message-ID: <BANLkTimON46Jquhy2-4RQHCL+Vi-BGy1UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When I've used btrfs subvolume, without separately mouting it, for
mysql database dir I've got
Fatal error: Can't open and lock privilege tables: Table 'host' is read only
when starting mysql. When I've put mysql database dir in root of
btrfs, not a subvolume, mysql works fine.
I've checked file for host table, but I could write to it no problem
(on subvolume without mouting). I dont know what could be the problem.
I did not check it when mouting a subvolume separately
