Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64806 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab2JWRvj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 13:51:39 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1518982eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 10:51:38 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH][BTRFS-PROGS][V2] Update to parse_size()
Date: Tue, 23 Oct 2012 19:51:50 +0200
Message-Id: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

the following patches attempt to address some issues to the function
parse_size():
- this function is defined both in mkfs.c and cmds-filesystem.c; I 
moved it in utils.c (which is already used in both mkfs.btrfs and
btrfs) in order to avoid code duplication.
- it used the function atoll(); I replaceed atoll() with strtoull() 
because we are dealing with u64
- no check on suffixes was performed. If the user put 'MB' as suffix he got
bytes instead megabytes. The patches check the suffix is valid
- add new suffixes (t,p,e for terabytes, petabytes, exabytes)
- update the man page of the command mkfs.btrfs and 
"btrfs filesystem defragment", both use parse_size()

Several peoples (see cc's) suggested these improvements with different 
patches, I collected them togheter.

Please reviewed them, test them. Comments are welcome.

The patches are available also to 

You can pull the patch from 
        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
        parse_size


Signed-off-by: Goffredo Baroncelli <kreij...@inwind.it>

Changelog:
V1: avoid to change the parse_size argument; 
    better check of a wrong suffix;
    force strtoull to use a decimal base

