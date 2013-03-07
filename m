Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab3CGJmg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 04:42:36 -0500
Date: Thu, 7 Mar 2013 10:42:34 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, stable@kernel.org
Subject: Re: [PATCH] btrfs: enhance superblock checks
Message-ID: <20130307094234.GI21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've missed an important detail in the reproducer, sorry

On Wed, Mar 06, 2013 at 04:56:40PM +0100, David Sterba wrote:
> Reproducer:
> $ mfks.btrfs /dev/sda
> $ mount /dev/sda /mnt
> $ btrfs scrub start /mnt

sleep 5

> $ btrfs scrub status /mnt
> ... super:2 ...

otherwise the scrub status is not updated yet.

$ scrub start
scrub started on /mnt/test, fsid afd3a16e-509b-451d-8608-4d47a7584917 (pid=5029)

$ scrub status
scrub status for afd3a16e-509b-451d-8608-4d47a7584917
        no stats available
        total bytes scrubbed: 0.00 with 0 errors
$ sleep 5

$ scrub status
scrub status for afd3a16e-509b-451d-8608-4d47a7584917
        scrub started at Thu Mar  7 10:37:16 2013 and finished after 1 seconds
        total bytes scrubbed: 56.00KB with 2 errors
        error details: super=2
        corrected errors: 0, uncorrectable errors: 0, unverified errors: 0
---
