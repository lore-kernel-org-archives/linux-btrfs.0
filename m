Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3KFRCa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 12:02:30 -0500
Date: Wed, 6 Nov 2013 18:02:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 00/13] [PATCH 00/13] sysfs publishing patchset (v2)
Message-ID: <20131106170226.GY16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131101170654.164867629@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131101170654.164867629@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 01:06:54PM -0400, Jeff Mahoney wrote:
> v2: An earlier version had a chunk intended for fs/btrfs/extent-tree.c
> added as part of patch 13 instead of patch 10, causing build failures.
> 
> <fsid>/devices/sdc1
> <fsid>/devices/sdd1
> <fsid>/label
> <fsid>/allocation/data/flags
...
> <fsid>/allocation/metadata/flags
...

How is the mixed blockgroup setup presented? I guess that the values
from used_bytes, total_bytes etc would be the same for data and metadata
and the flags would denote that it's mixed.

The sysfs hierarchy looks ok to me.

david
