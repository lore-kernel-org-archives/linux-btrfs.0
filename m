Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36573 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932183AbaGSRiM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 13:38:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during balance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140719172605.445e8445@marcec>
Date: Sat, 19 Jul 2014 11:38:08 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
References: <20140719172605.445e8445@marcec>
To: Marc Joliet <marcec@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 2nd dmesg (didn't look at the 1st), has many instances like this;

[96241.882138] ata2.00: exception Emask 0x1 SAct 0x7ffe0fff SErr 0x0 action 0x6 frozen
[96241.882139] ata2.00: Ata error. fis:0x21
[96241.882142] ata2.00: failed command: READ FPDMA QUEUED
[96241.882148] ata2.00: cmd 60/08:00:68:0a:2d/00:00:18:00:00/40 tag 0 ncq 4096 in
         res 41/00:58:40:5c:2c/00:00:18:00:00/40 Emask 0x1 (device error)

I'm not sure what this error is, it acts like an unrecoverable read error but I'm not seeing UNC reported. It looks like ata 2.00 is sdb, which is a member of a btrfs raid10 volume. So this isn't related to your sdg2 and enospc error, it's a different problem.


I'm not sure of the reason for the "BTRFS info (device sdg2): 2 enospc errors during balance" but it seems informational rather than either a warning or problem. I'd treat ext4->btrfs converted file systems to be something of an odd duck, in that it's uncommon, therefore isn't getting as much testing and extra caution is a good idea. Make frequent backups.

Chris Murphy