Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54650 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752512AbaIPVdJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:33:09 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [bug] btrfs check --subvol-extents segfault
Date: Tue, 16 Sep 2014 15:33:05 -0600
Message-Id: <BB091951-5382-4788-901D-20E96546548A@colorremedies.com>
Cc: "dsterba@suse.cz Sterba" <dsterba@suse.cz>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.redhat.com/show_bug.cgi?id=1142421

kernel-3.17.0-0.rc5.git0.1.fc22.x86_64
btrfs-progs-3.16-1.fc21.x86_64

Steps to Reproduce:
1. mkfs.btrfs /dev/sdc
2. btrfs check --subvol-extents /dev/sdc

Results:
Segmentation fault (core dumped)

[  632.749774] btrfs[692]: segfault at 0 ip 00007fc9963fdd77 sp 00007fff93450880 error 4 in libc-2.19.90.so[7fc9963c2000+1bd000]

Eric Sandeed writes in the bugzilla that this was broken by commit d34cbe76c723a05a14bbcfdc46e8ede789c3f1f9 which drops the requirement to specify a subvolid, but still does arg_strtou64(optarg) -> arg_strtou64(NULL) so it crashes.


Chris Murphy