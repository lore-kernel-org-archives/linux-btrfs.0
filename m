Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752304AbeCURvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 13:51:04 -0400
Date: Wed, 21 Mar 2018 18:48:38 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
Message-ID: <20180321174838.GW6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 19, 2018 at 05:16:42PM +0900, Misono, Tomohiro wrote:
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

So this adds uuid, ctime and otime to FS_TEEE but also to UUID_TREE and
DATA_RELOC_TREE. This is harmelss, but would be nice to mention in the
changelog, I'll apply the patch add that. Thanks.
