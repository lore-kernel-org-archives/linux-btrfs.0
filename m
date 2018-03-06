Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752784AbeCFQxY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Mar 2018 11:53:24 -0500
Date: Tue, 6 Mar 2018 17:51:04 +0100
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] btrfs: Add two new unprivileged ioctls to allow
 normal users to call "sub list/show" etc.
Message-ID: <20180306165103.GS5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cbc4534e-346f-40be-ca4f-5cd86c61af28@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 05:29:34PM +0900, Misono, Tomohiro wrote:
> This adds two new unprivileged ioctls:
> 
> 1st patch: version of tree_search ioctl which only searches/returns subvolume related item.
> 2nd patch: user version of ino_lookup ioctl which also performs permission check.
> 
> They will be used to implement user version of "subvolume list/show" etc in user tools.

The unprivileged separate listing ioctls are highly requested so I'm
looking forward to the feedback round.

The usecase coverage should be same what the current 'btrfs subvol list'
does, except the complex filtering.

The merging target for that shall be 4.18 which should give us enough
time to discuss and review the usecase or the ioctl capabilities and
data structure formats.
