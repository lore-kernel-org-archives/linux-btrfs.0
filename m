Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40217 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbHYISl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 04:18:41 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Date: Tue, 25 Aug 2015 10:18:26 +0200
Message-ID: <4755396.RFUxGNmK6p@tethys>
In-Reply-To: <pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net>
References: <2017000.AEG9PyVY17@zafu> <pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le vendredi 21 août 2015 11:23:19 Duncan a écrit :
> So I'd suggest running btrfs check, without --repair, first, and see what 
> it says.  If the only reported problems have to do with inode refcounts, 
> then (assuming your backups are current, just in case, admin's rule of 
> backups, if you don't have them, you don't care about losing the data) 
> I'd then go ahead and run it with --repair.

Hi Duncan,

Here's what I get using "btrfs check" on said device. Do you think that 
running it with "--repair" would be beneficial, or risky ?

root@partedmagic:~# btrfs check /dev/VGZ/LINUX 
Checking filesystem on /dev/VGZ/LINUX
UUID: 13c87f57-3a85-4daf-a4bf-ba777407c169
checking extents
checking free space cache
checking fs roots
root 267 inode 297 errors 200, dir isize wrong
root 267 inode 3341 errors 200, dir isize wrong
root 267 inode 324547 errors 200, dir isize wrong
root 9119 inode 297 errors 200, dir isize wrong
root 9119 inode 3341 errors 200, dir isize wrong
root 9119 inode 324547 errors 200, dir isize wrong
root 10972 inode 297 errors 200, dir isize wrong
root 10972 inode 3341 errors 200, dir isize wrong
root 10972 inode 324547 errors 200, dir isize wrong
root 12028 inode 297 errors 200, dir isize wrong
root 12028 inode 3341 errors 200, dir isize wrong
root 12028 inode 324547 errors 200, dir isize wrong
root 14103 inode 297 errors 200, dir isize wrong
root 14103 inode 3341 errors 200, dir isize wrong
root 14103 inode 324547 errors 200, dir isize wrong
root 16144 inode 297 errors 200, dir isize wrong
root 16144 inode 3341 errors 200, dir isize wrong
root 16144 inode 324547 errors 200, dir isize wrong
root 18136 inode 297 errors 200, dir isize wrong
root 18136 inode 3341 errors 200, dir isize wrong
root 18136 inode 324547 errors 200, dir isize wrong
root 20366 inode 297 errors 200, dir isize wrong
root 20366 inode 3341 errors 200, dir isize wrong
root 20366 inode 324547 errors 200, dir isize wrong
root 22870 inode 297 errors 200, dir isize wrong
root 22870 inode 3341 errors 200, dir isize wrong
root 22870 inode 324547 errors 200, dir isize wrong
root 23600 inode 297 errors 200, dir isize wrong
root 23600 inode 3341 errors 200, dir isize wrong
root 23600 inode 324547 errors 200, dir isize wrong
root 23700 inode 297 errors 200, dir isize wrong
root 23700 inode 3341 errors 200, dir isize wrong
root 23700 inode 324547 errors 200, dir isize wrong
root 23850 inode 297 errors 200, dir isize wrong
root 23850 inode 3341 errors 200, dir isize wrong
root 23850 inode 324547 errors 200, dir isize wrong
root 23993 inode 297 errors 200, dir isize wrong
root 23993 inode 3341 errors 200, dir isize wrong
root 23993 inode 324547 errors 200, dir isize wrong
root 24083 inode 297 errors 200, dir isize wrong
root 24083 inode 3341 errors 200, dir isize wrong
root 24083 inode 324547 errors 200, dir isize wrong
root 24133 inode 297 errors 200, dir isize wrong
root 24133 inode 3341 errors 200, dir isize wrong
root 24133 inode 324547 errors 200, dir isize wrong
root 24153 inode 297 errors 200, dir isize wrong
root 24153 inode 3341 errors 200, dir isize wrong
root 24153 inode 324547 errors 200, dir isize wrong
root 24163 inode 297 errors 200, dir isize wrong
root 24163 inode 3341 errors 200, dir isize wrong
root 24163 inode 324547 errors 200, dir isize wrong
root 24173 inode 297 errors 200, dir isize wrong
root 24173 inode 3341 errors 200, dir isize wrong
root 24173 inode 324547 errors 200, dir isize wrong
root 24183 inode 297 errors 200, dir isize wrong
root 24183 inode 3341 errors 200, dir isize wrong
root 24183 inode 324547 errors 200, dir isize wrong
root 24193 inode 297 errors 200, dir isize wrong
root 24193 inode 3341 errors 200, dir isize wrong
root 24193 inode 324547 errors 200, dir isize wrong
root 24205 inode 297 errors 200, dir isize wrong
root 24205 inode 3341 errors 200, dir isize wrong
root 24205 inode 324547 errors 200, dir isize wrong
root 24216 inode 297 errors 200, dir isize wrong
root 24216 inode 3341 errors 200, dir isize wrong
root 24216 inode 324547 errors 200, dir isize wrong
root 24226 inode 297 errors 200, dir isize wrong
root 24226 inode 3341 errors 200, dir isize wrong
root 24226 inode 324547 errors 200, dir isize wrong
root 24236 inode 297 errors 200, dir isize wrong
root 24236 inode 3341 errors 200, dir isize wrong
root 24236 inode 324547 errors 200, dir isize wrong
root 24246 inode 297 errors 200, dir isize wrong
root 24246 inode 3341 errors 200, dir isize wrong
root 24246 inode 324547 errors 200, dir isize wrong
root 24256 inode 297 errors 200, dir isize wrong
root 24256 inode 3341 errors 200, dir isize wrong
root 24256 inode 324547 errors 200, dir isize wrong
root 24266 inode 297 errors 200, dir isize wrong
root 24266 inode 3341 errors 200, dir isize wrong
root 24266 inode 324547 errors 200, dir isize wrong
root 24276 inode 297 errors 200, dir isize wrong
root 24276 inode 3341 errors 200, dir isize wrong
root 24276 inode 324547 errors 200, dir isize wrong
found 104803262666 bytes used err is 1
total csum bytes: 217220208
total tree bytes: 4058595328
total fs tree bytes: 3542876160
total extent tree bytes: 225337344
btree space waste bytes: 809904359
file data blocks allocated: 656106184704
 referenced 364340379648
Btrfs v3.18.2

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

