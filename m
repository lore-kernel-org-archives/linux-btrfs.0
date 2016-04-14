Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58722 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbcDNQ4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 12:56:37 -0400
Received: from mfilter33-d.gandi.net (mfilter33-d.gandi.net [217.70.178.164])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 86EF8A80E4
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 18:56:34 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([IPv6:::ffff:217.70.183.195])
	by mfilter33-d.gandi.net (mfilter33-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id Zfnva7rk63ff for <linux-btrfs@vger.kernel.org>;
	Thu, 14 Apr 2016 18:56:32 +0200 (CEST)
Received: from [192.168.1.16] (AMontpellier-656-1-414-190.w92-133.abo.wanadoo.fr [92.133.202.190])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 50182A80CF
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 18:56:32 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Subject: Help ! "btrfs check" looping recursive
Message-ID: <570FCBBD.2010500@petaramesh.org>
Date: Thu, 14 Apr 2016 18:56:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

It seems that i have a "btrfs check" process that’s stuck in an infinite
recursive loop…

How could I end this without breaking my filesystem ?

Help much needed & appreciated…

TIA.

Kind regards.


root@PartedMagic:~# btrfs check --repair /dev/VGZ/LINUX
enabling repair mode
Checking filesystem on /dev/VGZ/LINUX
UUID: 13c87f57-3a85-4daf-a4bf-ba777407c169
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
Deleting bad dir index [2188127,96,2152] root 267
Deleting bad dir index [2188127,96,2155] root 267
Deleting bad dir index [2188127,96,2152] root 40298
Deleting bad dir index [2188127,96,2155] root 40298
Deleting bad dir index [2188127,96,2152] root 40761
Deleting bad dir index [2188127,96,2155] root 40761
reset isize for dir 2188127 root 40815
Trying to rebuild inode:8089093
Can't determint the filetype for inode 8089093, assume it is a normal file
Can't get file name for inode 8089093, using '8089093' as fallback
Can't get file type for inode 8089093, using FILE as fallback
Moving file '8089093' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Trying to rebuild inode:8089098
Can't determint the filetype for inode 8089098, assume it is a normal file
Can't get file name for inode 8089098, using '8089098' as fallback
Can't get file type for inode 8089098, using FILE as fallback
Moving file '8089098' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file '8089093.8089093' to 'lost+found' dir since it has no valid
backref
Fixed the nlink of inode 8089093
root 40815 inode 8089093 errors 10, odd dir item
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file '8089098.8089098' to 'lost+found' dir since it has no valid
backref
Fixed the nlink of inode 8089098
root 40815 inode 8089098 errors 10, odd dir item
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file '8089093.8089093.8089093' to 'lost+found' dir since it has
no valid backref
Fixed the nlink of inode 8089093
root 40815 inode 8089093 errors 10, odd dir item
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file '8089098.8089098.8089098' to 'lost+found' dir since it has
no valid backref
Fixed the nlink of inode 8089098
root 40815 inode 8089098 errors 10, odd dir item
Deleting bad dir index [2188127,96,2152] root 40815
Deleting bad dir index [2188127,96,2155] root 40815
reset isize for dir 2188127 root 40815
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file '8089093.8089093.8089093.8089093' to 'lost+found' dir since
it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file '8089098.8089098.8089098.8089098' to 'lost+found' dir since
it has no valid backref
Fixed the nlink of inode 8089098
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file '8089093.8089093.8089093.8089093.8089093' to 'lost+found'
dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file '8089098.8089098.8089098.8089098.8089098' to 'lost+found'
dir since it has no valid backref
Fixed the nlink of inode 8089098
Deleting bad dir index [2188127,96,2152] root 40869
Deleting bad dir index [2188127,96,2155] root 40869
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file '8089093.8089093.8089093.8089093.8089093.8089093' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file '8089098.8089098.8089098.8089098.8089098.8089098' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file '8089093.8089093.8089093.8089093.8089093.8089093.8089093' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file '8089098.8089098.8089098.8089098.8089098.8089098.8089098' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file
'8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file
'8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098
Deleting bad dir index [2188127,96,2152] root 40905
Deleting bad dir index [2188127,96,2155] root 40905
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file
'8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file
'8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098' to
'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file
'8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093'
to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file
'8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098'
to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098
Deleting bad dir index [2188127,96,2152] root 41096
Deleting bad dir index [2188127,96,2155] root 41096
Can't get file name for inode 8089093, using '8089093' as fallback
Moving file
'8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093.8089093'
to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089093
Can't get file name for inode 8089098, using '8089098' as fallback
Moving file
'8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098.8089098'
to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 8089098

Ad lib…

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


