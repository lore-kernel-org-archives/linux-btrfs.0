Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbeCZNYZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 09:24:25 -0400
Date: Mon, 26 Mar 2018 15:21:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM
 of, FS_TREE
Message-ID: <20180326132158.GL6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
 <f620135f-3a06-c871-3289-881a6bfbc0f1@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f620135f-3a06-c871-3289-881a6bfbc0f1@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 23, 2018 at 05:16:49PM +0900, Misono Tomohiro wrote:
> Currently, the top-level subvolume lacks the UUID. As a result, both
> non-snapshot subvolume and snapshot of top-level subvolume do not have
> Parent UUID and cannot be distinguisued. Therefore "fi show" of
> top-level lists all the subvolumes which lacks the UUID in
> "Snapshot(s)" filed.  Also, it lacks the otime information.
> 
> Fix this by adding the UUID and otime at the mkfs time.  As a
> consequence, snapshots of top-level subvolume now have a Parent UUID and
> UUID tree will create an entry for top-level subvolume at mount time.
> This should not cause the problem for current kernel, but user program
> which relies on the empty Parent UUID may be affected by this change.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
> v1 -> v2: clear o/ctime in create_tree()

Yeah that's better, thanks. Patch replaced.
