Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbeIKNoo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 09:44:44 -0400
Date: Tue, 11 Sep 2018 10:46:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs: qgroup: Skip unrelated tree blocks for
 balance
Message-ID: <20180911084607.GA24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180907093235.28254-1-wqu@suse.com>
 <365a6700-4a69-4997-1546-b90710d9d8d3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <365a6700-4a69-4997-1546-b90710d9d8d3@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 10:43:32AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/9/7 下午5:32, Qu Wenruo wrote:
> > This patchset can be fetched from github:
> > https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
> > The base commit is v4.19-rc1 tag.
> > 
> > There are a lot of reports of system hang for balance on quota enabled
> > fs.
> > It's most obvious for large fs.
> > 
> > The hang is caused by tons of unmodified extents marked as qgroup dirty.
> > Such unmodified/unrelated sources include:
> > 1) Unmodified subtree
> > 2) Subtree drop for reloc tree
> > (BTW, other sources includes unmodified file extent items)
> > 
> > E.g.
> > OO = Old tree blocks from file tree
> > NN = New tree blocks from reloc tree
> > 
> >         file tree                              reloc tree
> >            OO (a)                                  NN (a)
> >           /  \                                    /  \
> >     (b) OO    OO (c)                        (b) NN    NN (c)
> >        / \   / \                               / \   / \
> >      OO  OO OO  OO                           OO  OO OO  NN
> >     (d) (e) (f) (g)                         (d) (e) (f) (g)
> > 
> > In above case, balance will modify nodeptr in OO(a) to point NN(b) and
> > NN(c), and modify NN(a) to point to OO(B) and OO(c).
> > 
> > Before this patch, quota will mark the whole subtree from its parent
> > down to the leaves as dirty.
> > So btrfs quota need to trace all tree block from (a) to (g).
> > 
> > However tree blocks (d) (e) (f) are shared between both trees, thus
> > there is no need to trace those 3 tree blocks.
> > 
> > This patchset will change how this work by only tracing modified tree
> > blocks in reloc tree, and their counter parts in file tree.
> > 
> > Nodeptr swap will happen for tree blocks (b) and (c) in both tree.
> > 
> > For tree block (b), in reloc tree we could find that all its
> > children's generation is smaller than last_snapshot, thus no need to
> > trace them, only need to trace NN(b), and its counter part OO(b).
> > 
> > For tree block (c), in reloc tree, we find its child NN(g) need
> > tracing, and for tree block NN(g), there is no child need to trace.
> > 
> > So for subtree starting at tree block NN(c), we need to trace NN(c) and
> > NN(g), along with its counter part OO(c) and OO(c).
> > 
> > With this patch, we could skip tree blocks OO(d)~OO(f) in above example,
> > thus reduce some some overhead caused by qgroup.
> > 
> > The improvement is mostly related to metadata relocation.
> > If there is some high level tree blocks get relocated but its children are
> > still unmodified, we could save a lot of time.
> > 
> > Even for the worst case, it should be no worse than original full
> > subtree marking method.
> > 
> > Real world case benchmark is under way.
> 
> Did a small scale test. (With latest submitted patch "btrfs:
> delayed-ref: Introduce new parameter for btrfs_add_delayed_tree_ref() to
> reduce unnecessary qgroup tracing")
> 
> 4K nodesize fs (to bump tree sizes), around 4G data copied from /usr and
> /lib (so number of files should be large enough).
> 
> The VM has unsafe cache mode for its qcow2 file, and the backing device
> is a SAMSUNG 850 evo sata SSD. (Host has enough RAM so most IO should be
> as fast as RAM speed).
> 
> The for metadata only balance:
> 
>                      | Before          | After       | Diff
> --------------------------------------------------------------------------
> relocated extents    | 21112           | 22916       | +8.5%
> qgroup dirty extents | 213831          | 140731      | -30.0%
> time (sys)           | 7.828s          | 5.818s      | -25.7%
> time (real)          | 10.004s         | 7.768s      | -22.3%

Thanks, this looks good. I'd speculate that the improvement on systems
where the IO is not memory backed will be improved by the reduced count
of the dirty extents. But the memory-backed IO results look good on
itself.

I'll add the patches to for-next, feel free to send more testing results
or updates. Thanks.
