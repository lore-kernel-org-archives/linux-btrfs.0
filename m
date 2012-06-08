Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:54553 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab2FHTMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:12:52 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [RFC][btrfs-progs] add command btrfs filesystem info
Date: Fri,  8 Jun 2012 21:12:43 +0200
Message-Id: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

the aim of this patch is to add the command "btrfs filesystem info" to 
show some filesystem information. Example:

$ sudo btrfs-progs/btrfs filesystem info /mnt/test
Path: /mnt/test
Max ID: 4
UUID: 1c7e4ba6-aebc-4b39-90ef-c61315fb74d1

Num devices: 3
  Dev ID: 2
  UUID: cdbda186-735e-49cd-babc-e84fffdb4105
  Bytes used: 511705088
  Total bytes: 1667235840
  Path: /dev/loop1
  Dev ID: 3
  UUID: a4cebf4e-f760-49a7-b960-142b2c14d9e6
  Bytes used: 0
  Total bytes: 1111490560
  Path: /dev/loop2
  Dev ID: 4
  UUID: 61bd5825-f86e-4708-8a5b-f48764b5c3a5
  Bytes used: 0
  Total bytes: 1111490560
  Path: /dev/loop3

I make that because it is not so trivial to get these information otherwise.

To get the information, I made public and used: scrub_device_info() and 
scrub_fs_info(). So, I moved the functions to the file utils.c changing 
scrub_ to get_. I was inspired by a patch of Stefan Behrens.

Next enhancements:
- remove the root privileges to launch the command (require change in
kernel space)
- show also the label of the filesystem (same as above)

Please review; as usual, comments are welcome.

You can pull the changes from the reposiotry
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch 
	filesystem-info

BR
G.Baroncelli

 Makefile          |    8 +++---
 cmds-filesystem.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 cmds-scrub.c      |   72 +-----------------------------------------------------
 man/btrfs.8.in    |    8 ++++++
 utils.c           |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |    4 +++
 6 files changed, 145 insertions(+), 74 deletions(-)


