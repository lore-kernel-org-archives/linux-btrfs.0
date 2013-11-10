Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41677 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3KJMya (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 07:54:30 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs might be gradually slowing the boot process
Date: Sun, 10 Nov 2013 23:54:26 +1100
Cc: linux-btrfs@vger.kernel.org
References: <527d2ee689e077.81319728@wp.pl> <04B39B7F-24A2-42E0-8C4A-31D710A844E6@colorremedies.com> <pan$4dd5e$f5631722$5803e40a$fdc51295@cox.net>
In-Reply-To: <pan$4dd5e$f5631722$5803e40a$fdc51295@cox.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CI4fSOJMV8Wsybt"
Message-Id: <201311102354.26799.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_CI4fSOJMV8Wsybt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sun, 10 Nov 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Sat, 09 Nov 2013 21:53:10 -0700 as excerpted:
> > What's leafsize was used when making the file system? The default is now
> > (as of yesterday) 16KB to avoid metadata fragmentation.
> 
> I saw the discussion of that, but two questions it didn't answer -- (1) 
> what was the default size before, and (2) how do I check what I actually 
> have?

I've attached the Debian patch to the magic database for file(1) to display 
BTRFS data, it gives output such as the following.  The magic database 
displayed the leafsize before this patch, but the patch displays the UUID 
(which you REALLY want to know) and all the other information I could figure 
out.

# file -s /dev/dm-0
/dev/dm-0: BTRFS Filesystem sectorsize 4096, nodesize 4096, leafsize 4096, 
UUID=586e6f48-2985-4115-9f89-f844b319c7c0, 82545332224/115536781312 bytes 
used, 1 devices

I might file another bug report with a new version to display error counts 
etc.  I think that all data which we can extract should be displayed to the 
user.  As an aside, I don't know if the bytes used field is going to be very 
useful on a RAID-0 filesystem, but it's there and I think we might as well 
show it.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

--Boundary-00=_CI4fSOJMV8Wsybt
Content-Type: text/x-patch;
  charset="ISO-8859-1";
  name="0011-btrfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0011-btrfs.patch"

Author: Russell Coker <russell@coker.com.au>
Description: Adding updated magics for BTRFS (Closes: #663454).

diff -Naurp file.orig/magic/Magdir/filesystems file/magic/Magdir/filesystems
--- file.orig/magic/Magdir/filesystems	2013-03-13 16:54:43.588452886 +0100
+++ file/magic/Magdir/filesystems	2013-03-13 17:15:59.659044842 +0100
@@ -1894,12 +1894,21 @@
 >>0x10060        string          >\0             lockproto %s)
 
 # BTRFS
-0x10040         string          _BHRfS_M        BTRFS Filesystem
->0x1012b        string          >\0             (label "%s",
->0x10090        lelong          x               sectorsize %d,
->0x10094        lelong          x               nodesize %d,
->0x10098        lelong          x               leafsize %d)
-
+# Russell Coker <russell@coker.com.au>
+0x10040	string	_BHRfS_M	BTRFS Filesystem
+>0x1012b	string	>\0		label "%s",
+>0x10090	lelong	x		sectorsize %d,
+>0x10094	lelong	x		nodesize %d,
+>0x10098	lelong	x		leafsize %d,
+>0x10020	belong	x		UUID=%8x-
+>0x10024	beshort	x		\b%4x-
+>0x10026	beshort	x		\b%4x-
+>0x10028	beshort	x		\b%4x-
+>0x1002a	beshort	x		\b%4x
+>0x1002c	belong	x		\b%8x,
+>0x10078	lequad	x		%lld/
+>0x10070	lequad	x		\b%lld bytes used,
+>0x10088	lequad	x		%lld devices
 
 # dvdisaster's .ecc
 # From: "Nelson A. de Oliveira" <naoliv@gmail.com>

--Boundary-00=_CI4fSOJMV8Wsybt--
