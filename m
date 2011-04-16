From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: btrfs frozen solid with postgresql dbs
Date: Sat, 16 Apr 2011 15:07:50 +0200
Message-ID: <BANLkTimFNpi_AF_n6-=gOp1N1U12QturyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

kernel: 2.6.37.6

At least twice I've experienced problems when using btrfs with ssd for
postgresql db storage. Server gets frozen, i even can't kill it using
kill -9, I cant chown postgresql db dir (it never gets done). If I
initiate copy operation of postgresql db dir to another partition
(without actually switching to using it) everything starts to work
fine for some time...
I've been using btrfs for mysql storage dir also. I did not observe
any problems so far.
