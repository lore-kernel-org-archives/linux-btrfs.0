Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54324 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaKIDzM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Nov 2014 22:55:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XnJam-0005ao-RS
	for linux-btrfs@vger.kernel.org; Sun, 09 Nov 2014 04:55:11 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Nov 2014 04:55:08 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Nov 2014 04:55:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: [btrfs-progs] cmds-restore.c:182:20: warning: array subscript is
 above array bounds [-Warray-bounds]
Date: Sun, 9 Nov 2014 03:54:56 +0000 (UTC)
Message-ID: <pan$7e207$ad1fefbf$2a4c2d19$75d64f5f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Updating to the latest live-git btrfs-progs (on v3.17.1 tag), I chanced 
across this (gentoo) warning, pointing to a gcc warning believed to be 
severe:

 * QA Notice: Package triggers severe warnings which indicate that it
 *            may exhibit random runtime failures.
 * cmds-restore.c:182:20: warning: array subscript is above array bounds 
[-Warray-bounds]

 * Please do not file a Gentoo bug and instead report the above QA
 * issues directly to the upstream developers of this software.
 * Homepage: https://btrfs.wiki.kernel.org

A bit more context:

cmds-restore.c: In function 'next_leaf':
cmds-restore.c:182:20: warning: array subscript is above array bounds
[-Warray-bounds]
  slot = path->slots[level] + 1;
                    ^

Not being a coder I've no idea if it's a false-alarm or not, and I 
generally ignore these QA warnings since I've little hope of providing 
much more than the basic information or help, but since I'm already 
active here I thought I'd post it and see what happens.

FWIW, gentoo/~amd64, gcc-4.8.3.

Full build log available if needed altho I expect it should be easy 
enough to trace without.  Note that I normally build with
MAKEOPTS="-j10 -l8" so if log serialization is desired, please request
a -j1 build log.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

