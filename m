From: "Helmut Hullen" <Hullen@t-online.de>
Subject: SI units
Date: 18 Nov 2010 14:13:00 +0100
Message-ID: <Ba6eIYZT1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

when I invoke

        btrfs filesystem show

then it shows the size of my Terabyte disks in TiByte but tells "TB".  
It's a difference of about 10% - either there should be a switch like in  
"df" (option -H or --si), or "TB" should be changed to "TiB" (the same  
with GiB, MiB etc.)

Viele Gruesse!
Helmut
