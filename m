Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42294 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2GYEjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 00:39:39 -0400
Received: by obbuo13 with SMTP id uo13so521505obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 21:39:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Jul 2012 14:39:38 +1000
Message-ID: <CA+WRLO-rXZ7FvjpUbC7F8x2Dqr0j=YnZ5OtTvXbc_uBoXR92OA@mail.gmail.com>
Subject: Upgrading from 2.6.38, how?
From: Gareth Pye <gareth@cerberos.id.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Firstly I know what I've been doing has been less than 100% safe, but
I've been prepared to live with it.

For about 2 years now (you know from around the time btrfs looked like
RAID5/6 was just around the corner) I've had a server with a 5 disk
RAID10 btrfs array. I realise there has been quite some change to the
btrfs implementation since 2.6.38 but I'm hoping that there shouldn't
be anything blocking me moving to a much more modern kernel.

My proposed upgrade method is:
Boot from a live CD with the latest kernel I can find so I can do a few tests:
 A - run the fsck in read only mode to confirm things look good
 B - mount read only, confirm that I can read files well
 C - mount read write, confirm working
Install latest OS, upgrade to latest kernel, then repeat above steps.

Any likely hiccups with the above procedure and suggested alternatives?

-- 
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum: mtgau.com
gareth@cerberos.id.au - www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
