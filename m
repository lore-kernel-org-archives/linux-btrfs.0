Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38658 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbeEANmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 09:42:10 -0400
Date: Tue, 1 May 2018 15:39:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <obuil.liubo@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: set keep_lock when necessary in
 btrfs_defrag_leaves
Message-ID: <20180501133933.GR21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524706063-93210-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180426180659.GX21272@twin.jikos.cz>
 <CANQeFDCWvuU06eN-TR1VPKDKHYDSHr_2TDRjhczHiPfc_skRuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANQeFDCWvuU06eN-TR1VPKDKHYDSHr_2TDRjhczHiPfc_skRuw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 01:36:35PM +0800, Liu Bo wrote:
> > What does btrfs_search_forward do as the first statement:
> >
> > 5115 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
> > 5116                          struct btrfs_path *path,
> > 5117                          u64 min_trans)
> > 5118 {
> > .... declarations
> > 5128
> > 5129         path->keep_locks = 1;
> >
> > So even if removed from above, there will be no change. The value of
> > keep_locks is preserved after btrfs_path_release.
> >
> 
> FYI, btrfs_search_forward() doesn't need keep_locks's semantics as all
> of its callers only access path->nodes[0], thus I'm planning to remove
> keep_locks setting inside it, too.

Ok.

Please update the changelog of this patch and note something about
btrfs_search_forward that sets the path lock on it's own and that
there's no change in defrag leaves.
