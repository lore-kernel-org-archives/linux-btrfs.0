Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fe1.lbl.gov ([128.3.41.133]:20101 "EHLO fe1.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbaDGXYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 19:24:36 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so131563pab.40
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 16:14:59 -0700 (PDT)
Received: from [128.3.5.130] (apersaud.dhcp.lbl.gov. [128.3.5.130])
        by mx.google.com with ESMTPSA id et3sm311320pbc.52.2014.04.07.16.14.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 07 Apr 2014 16:14:58 -0700 (PDT)
Message-ID: <53433170.5030806@lbl.gov>
Date: Mon, 07 Apr 2014 16:14:56 -0700
From: Arun Persaud <apersaud@lbl.gov>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: error 2001, no inode item
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

my HD recently started crashing, so I rescued all files to a new one and
thought that this might be a good time to convert from ext4 to btrfs. I
copied all the files from my old HD using dd, converted and then resized
the file system. However, my old drive already had some errors.
Currently I have one file that I can't rm or overwrite (stale file
handle). Here is what I get when running btrfs check:

> btrfs check /dev/sda4

checking extents
checking free space cache
checking fs roots
root 5 inode 5769204 errors 2001, no inode item, link count wrong
	unresolved ref dir 5783881 index 3 namelen 38 name
61bd2ed1fba8bc8d2f12766c7e4b3dafff6350 filetype 1 error 4, no inode ref
root 5 inode 5899187 errors 2001, no inode item, link count wrong
	unresolved ref dir 5906761 index 3 namelen 38 name
61bd2ed1fba8bc8d2f12766c7e4b3dafff6350 filetype 1 error 0
Checking filesystem on /dev/sda4
UUID: 98190f1e-426f-433d-8335-1216b9a63d16
cache and super generation don't match, space cache will be invalidated
found 6932789174 bytes used err is 1
total csum bytes: 123239772
total tree bytes: 702812160
total fs tree bytes: 534839296
total extent tree bytes: 32509952
btree space waste bytes: 163897229
file data blocks allocated: 349199831040
 referenced 126131052544
Btrfs v3.12+20131125

the file is a git object, so that's why the name looks like a hash ;)

> uname -a
Linux apersaud 3.14.0-23.gfa168d7-desktop #1 SMP PREEMPT Tue Apr 1
12:54:08 UTC 2014 (fa168d7) x86_64 x86_64 x86_64 GNU/Linux

I'm running opensuse/Tumbleweed.

Any idea how I can fix the above? check --repair doesn't seem to help.
Any suggestions would be highly appreciated.

thanks

Arun
