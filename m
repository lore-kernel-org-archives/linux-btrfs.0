Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36468 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689Ab2J2Rwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:52:43 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2229913eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 10:52:41 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH][BTRFS-PROGS][V3] Update to parse_size()
Date: Mon, 29 Oct 2012 18:53:16 +0100
Message-Id: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
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


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Changelog:
V3: Corrected few code style issues; replace a wrong "prefix" with suffix in
    the man page. Added Signed-off-by in every patch.
V2 -> skipped due to a worng subject in previous emails
V1: avoid to change the parse_size argument; 
    better check of a wrong suffix;
    force strtoull to use a decimal base


