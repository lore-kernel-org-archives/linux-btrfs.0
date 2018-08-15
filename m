Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728896AbeHOP6T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 11:58:19 -0400
Date: Wed, 15 Aug 2018 15:06:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH v5] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
Message-ID: <20180815130605.GO24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 09, 2018 at 04:05:36PM +0900, Misono Tomohiro wrote:
> When qgroup is on, subvolume deletion does not remove qgroup items
> of the subvolume (qgroup info, limit, relation) from quota tree and
> they need to get removed manually by "btrfs qgroup destroy".
> 
> Since level 0 qgroup cannot be used/inherited by any other subvolume,
> let's remove them automatically when subvolume is deleted
> (to be precise, when the subvolume root is dropped).

Please note that dropping the 0-level qgroup has user-visible impact
that needs to be evaluated. I don't see anything like that in the
changelog. If there's a potential or actual breakage after this patch,
it needs to be addressed in some way.

This is not the first time somebody proposes to do the auto deletion.
While I'm not against it, it still has to be done the right way.
Anything that touches user interfaces must get extra care, and review
bandwidth for that is unfortunatelly extra low. I can't give you an ETA
or merge target for this patch.
