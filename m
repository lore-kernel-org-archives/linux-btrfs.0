From: "Helmut Hullen" <Hullen@t-online.de>
Subject: btrfs-control: no such device
Date: 08 Apr 2011 14:00:00 +0200
Message-ID: <BjSyMGwD1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

when I run "balance" or "delete" and "/dev/btrfs-control" doesn't exist  
or is nor properly designed (I don't use "udev") then the program shows  
an error message and then continiues its work; the result is garbage.

The programs (or program options) which use a wellformed device "btrfs- 
control" should stop working if there is "no such device".

Viele Gruesse!
Helmut
