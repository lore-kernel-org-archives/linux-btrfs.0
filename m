Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51449 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaDPGl6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 02:41:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WaJXh-0004t7-BI
	for linux-btrfs@vger.kernel.org; Wed, 16 Apr 2014 08:41:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 08:41:57 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 08:41:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: btrfs-progs v3.14 mkfs.btrfs bug: --features long-option segfaults,
 -O short-option OK
Date: Wed, 16 Apr 2014 06:41:44 +0000 (UTC)
Message-ID: <pan$63522$eac299d1$60270bae$97109238@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using btrfs-progs v3.14:

mkfs.btrfs ... --features ...

segfaults.

mkfs.btrfs ... -O ...

works fine.

* I used other long options, so it's not simply a problem parsing long 
options.

* I tried the long option with various features; none worked, including 
--features list-all with no other options.  That too segfaulted, tho -O 
list-all worked.

Segfault line as logged:

mkfs.btrfs[5231]: segfault at 0 ip 00007fb531c7ab1a sp 00007fffaf1a7a78 
error 4 in libc-2.19.so[7fb531bf8000+19a000]

btrfs-progs v3.14 from git on kernel v3.14 from git, gentoo/~amd64, built 
with gcc-4.8.2, using glibc-2.19.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

