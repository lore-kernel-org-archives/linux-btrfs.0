Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab3AVRuW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:50:22 -0500
Date: Tue, 22 Jan 2013 18:50:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org,
        Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>,
        michael@codesrc.com
Subject: Re: [PATCH 02/13] Btrfs-progs: fix resolving of loop devices
Message-ID: <20130122175018.GF28263@twin.jikos.cz>
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

For the record, there was another patch fixing a loop device issue

https://patchwork.kernel.org/patch/1861831/

from Michael (CCed), that switched from LOOP_GET_STATUS to
LOOP_GET_STATUS64, but afaics both types of the ioctl return at most 64
characters, so parsing /sys appears to be the way to go.

david
