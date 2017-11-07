Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdKGOWF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 09:22:05 -0500
Date: Tue, 7 Nov 2017 15:20:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: switch uuid tree semaphore to mutex
Message-ID: <20171107142012.GA27557@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171106182402.11500-1-dsterba@suse.com>
 <CAL3q7H6n8sxOjE8tRBmCMFSjF=F9_B1dNkaGj0FD3UO5=95u+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6n8sxOjE8tRBmCMFSjF=F9_B1dNkaGj0FD3UO5=95u+w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 07, 2017 at 01:58:12PM +0000, Filipe Manana wrote:
> On Mon, Nov 6, 2017 at 6:24 PM, David Sterba <dsterba@suse.com> wrote:
> > @@ -3696,9 +3696,9 @@ void close_ctree(struct btrfs_fs_info *fs_info)
> >         btrfs_qgroup_wait_for_completion(fs_info, false);
> >
> >         /* wait for the uuid_scan task to finish */
> > -       down(&fs_info->uuid_tree_rescan_sem);
> > +       mutex_lock(&fs_info->uuid_tree_mutex);
> >         /* avoid complains from lockdep et al., set sem back to initial state */
> 
> This comment should go away too.

Agreed, removed in v2.
