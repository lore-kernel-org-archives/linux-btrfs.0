Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbcEIQuw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 12:50:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5DF76ACD5
	for <linux-btrfs@vger.kernel.org>; Mon,  9 May 2016 16:50:50 +0000 (UTC)
Date: Mon, 9 May 2016 18:50:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: udev: add rules for dm devices
Message-ID: <20160509165030.GN29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <10316a5a-513b-4db0-b629-5956b52bdd70@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <10316a5a-513b-4db0-b629-5956b52bdd70@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 09, 2016 at 11:44:26AM -0400, Jeff Mahoney wrote:
> Systemd's btrfs rule runs btrfs dev ready on each device
> as it's discovered.  The btrfs command is executed as a builtin
> command via an IMPORT{builtin} rule, which means it gets
> executed at rule evaluation time, not rule execution time.  That
> means that the device mapper links haven't been setup yet and the only
> nodes that can be depended upon are /dev/dm-#.  That we see
> /dev/mapper/name names in /proc/mounts is only because we replace the
> device name we have cached with the one passed in via mount.  If
> we have a multi-device file system and the primary device is removed,
> the remaining devices will show /dev/dm-#.  In addition, if the
> udev rule is executed again by someone generating a change event (e.g.
> partprobe), the names are also replaced by the /dev/dm-# names.
> 
> This patch adds a new rule that adds a run rule that calls btrfs dev
> ready again using the device mapper links once they're created.

Applied, thanks.
