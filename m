Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52934 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752319AbdIXNYD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 09:24:03 -0400
Date: Sun, 24 Sep 2017 15:22:29 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [PATCH v2 0/3] btrfs: cleanup mount path
Message-ID: <20170924132229.GR29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 22, 2017 at 02:56:49PM +0900, Misono, Tomohiro wrote:
> Summary:
> Cleanup mount path by avoiding calling btrfs_mount() twice.

That would be great to get rid of it, but please do it in smaller steps,
each of them being bisectable and preserving the existing functionality.

Patch 1/3 does not compile on any branch (master, v4.13, current devel
queue), removes the ability to mount via subvolume. I don't undserstand
(yet) why the other filesystem type is introduced as it is exactly the
same as the one we have now.

The description in the cover leter of the overall logic of the mount
should be added as a comment before btrfs_mount.
