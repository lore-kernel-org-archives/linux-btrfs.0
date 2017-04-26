Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753309AbdDZQIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Apr 2017 12:08:15 -0400
Date: Wed, 26 Apr 2017 18:08:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs, updates for 4.12
Message-ID: <20170426160808.GB23260@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1492601450.git.dsterba@suse.com>
 <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 26, 2017 at 04:06:29PM +0100, Filipe Manana wrote:
> On Wed, Apr 19, 2017 at 12:35 PM, David Sterba <dsterba@suse.com> wrote:
> > Adam Borowski (1):
> >       btrfs: fix a bogus warning when converting only data or metadata
> >
> > Anand Jain (3):
> >       btrfs: use q which is already obtained from bdev_get_queue
> >       btrfs: delete unused member nobarriers
> >       btrfs: check if the device is flush capable
> >
> > Dan Carpenter (1):
> >       Btrfs: handle only applicable errors returned by btrfs_get_extent
> >
> > David Sterba (12):
> >       btrfs: preallocate radix tree node for readahead
> >       btrfs: preallocate radix tree node for global readahead tree
> >       btrfs: remove redundant parameter from btree_readahead_hook
> >       btrfs: remove redundant parameter from reada_find_zone
> >       btrfs: remove redundant parameter from reada_start_machine_dev
> >       btrfs: remove local blocksize variable in reada_find_extent
> >       btrfs: remove unused qgroup members from btrfs_trans_handle
> >       btrfs: track exclusive filesystem operation in flags
> >       btrfs: sink GFP flags parameter to tree_mod_log_insert_move
> >       btrfs: sink GFP flags parameter to tree_mod_log_insert_root
> >       btrfs: drop redundant parameters from btrfs_map_sblock
> >       btrfs: use clear_page where appropriate
> 
> Did you actually ran xfstests with those readahead patches to
> preallocate radix tree nodes?
> 
> With those 2 patches applied (Chris' for-linus.4,12 branch) this
> breaks things and many btrfs specific tests (at least, since I can't
> get pass them) result in tons of traces like the following in a debug
> kernel:

I did, no such reports appeared in my setup. There are several debugging
options enabled in the config but I don't see the one to catch sleep in
atomic. I'll fix my setup scripts to enable it before each build. There
might be other surprises that I missed though. Thanks for cathing it.
