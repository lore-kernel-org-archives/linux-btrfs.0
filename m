Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3AUQO3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 11:14:29 -0500
Date: Mon, 21 Jan 2013 17:14:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org,
        Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>,
        hector.oron@collabora.co.uk
Subject: Re: [PATCH 02/13] Btrfs-progs: fix resolving of loop devices
Message-ID: <20130121161427.GJ19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-3-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358715858-4469-3-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 04:04:07PM -0500, Gene Czarcinski wrote:
> From: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>
> 
> The LOOP_GET_STATUS ioctl truncates filenames to 64 characters. We should get
> the backing file for a given loop device from /sys/. This is how losetup does it
> as well.
> 
> Signed-off-by: Gene Czarcinski <gene@czarc.net>

I'd expect Nirbheek's signed off here as well and I've noticed

Tested-By: Hector Oron <hector.oron@collabora.co.uk>
(https://patchwork.kernel.org/patch/1629581/)

Are you guys ok with adding them?

david
