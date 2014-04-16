Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbaDPHzO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 03:55:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WaKgb-00025g-UN
	for linux-btrfs@vger.kernel.org; Wed, 16 Apr 2014 09:55:13 +0200
Received: from p5b005b53.dip0.t-ipconnect.de ([91.0.91.83])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 09:55:13 +0200
Received: from holger.hoffstaette by p5b005b53.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 09:55:13 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: btrfs-progs v3.14 mkfs.btrfs bug: --features long-option
 segfaults, -O short-option OK
Date: Wed, 16 Apr 2014 07:55:00 +0000 (UTC)
Message-ID: <pan.2014.04.16.07.55.00@googlemail.com>
References: <pan$63522$eac299d1$60270bae$97109238@cox.net>
	<pan.2014.04.16.07.48.53@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Apr 2014 07:48:53 +0000, Holger Hoffstätte wrote:

> On Wed, 16 Apr 2014 06:41:44 +0000, Duncan wrote:
> 
>> Using btrfs-progs v3.14:
>> 
>> mkfs.btrfs ... --features ...
>> 
>> segfaults.
> 
> Can reproduce (also with glibc 2.19 on Gentoo ;-) and building with debug
> found:
> 
> (gdb) bt
> #0  0x00007ffff6f3aaea in strlen () from /lib64/libc.so.6
> #1  0x00007ffff6f3a82e in strdup () from /lib64/libc.so.6
> #2  0x00000000004213e8 in main (ac=2, av=0x7fffffffe308) at mkfs.c:1312
> 
> Sure enough that line is handling 'O', where '--features' is supposed to
> be handled. No idea why -O works, but debugging shows that optarg is null
> at that point, so strdup goes poof.

Well, duh! The long_options array does not declare that --features wants
an argument, so getopt does not create one.

holger>diff -u mkfs.c\~ mkfs.c
--- mkfs.c~	2014-04-16 09:41:42.000000000 +0200
+++ mkfs.c	2014-04-16 09:51:45.408854096 +0200
@@ -350,7 +350,7 @@
 	{ "version", 0, NULL, 'V' },
 	{ "rootdir", 1, NULL, 'r' },
 	{ "nodiscard", 0, NULL, 'K' },
-	{ "features", 0, NULL, 'O' },
+	{ "features", 1, NULL, 'O' },
 	{ NULL, 0, NULL, 0}
 };

This fixes it.

-h

