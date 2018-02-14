Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50002 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966225AbeBNBRJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 20:17:09 -0500
Date: Tue, 13 Feb 2018 17:14:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-cleaner / snapshot performance analysis
Message-ID: <20180214011401.GA5201@magnolia>
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <659ed727-f5dc-e81b-c01c-b6a063f3ed34@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <659ed727-f5dc-e81b-c01c-b6a063f3ed34@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 11, 2018 at 02:40:16PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年02月10日 00:45, Ellis H. Wilson III wrote:
> > Hi all,
> > 
> > I am trying to better understand how the cleaner kthread (btrfs-cleaner)
> > impacts foreground performance, specifically during snapshot deletion.
> > My experience so far has been that it can be dramatically disruptive to
> > foreground I/O.
> > 
> > Looking through the wiki at kernel.org I have not yet stumbled onto any
> > analysis that would shed light on this specific problem.  I have found
> > numerous complaints about btrfs-cleaner online, especially relating to
> > quotas being enabled.  This has proven thus far less than helpful, as
> > the response tends to be "use less snapshots," or "disable quotas," both
> > of which strike me as intellectually unsatisfying answers, especially
> > the former in a filesystem where snapshots are supposed to be
> > "first-class citizens."
> 
> Yes, snapshots of btrfs is really "first-class citizen".
> Tons of designs are all biased to snapshot.
> 
> But one should be clear about one thing:
> Snapshot creation and backref walk (used in qgroup, relocation and
> extent deletion), are two conflicting workload in fact.
> 
> Btrfs puts snapshot creation on a very high priority, so that it greatly
> degrades the performance of backref walk (used in snapshot deletion,
> relocation and extent exclusive/shared calculation of qgroup).
> 
> Let me explain this problem in detail.
> 
> Just as explained by Peter Grandi, for any snapshot system (or any
> system supports reflink) there must be a reserved mapping tree, to tell
> which extent is used by who.
> 
> It's very critical, to determine if an extent is shared so we determine
> if we need to do CoW.
> 
> There are several different ways to implement it, and this hugely
> affects snapshot creation performance.
> 
> 1) Direct mapping record
>    Just records exactly which extent is used by who, directly.
>    So when we needs to check the owner, just search the tree ONCE, then
>    we get it.
> 
>    This is simple and it seems that LVM thin-provision and LVM
>    traditional targets are all using them.
>    (Maybe XFS also follows this way?)

Yes, it does.

>    Pros:
>    *FAST* backref walk, which means quick extent deletion and CoW
>    condition check.
> 
> 
>    Cons:
>    *SLOW* snapshot creation.
>    Each snapshot creation needs to insert new owner relationship into
>    the tree. This modification grow with the size of snapshot source.

...of course xfs also doesn't support snapshots. :)

--D

> 2) Indirect mapping record
>    Records upper level referencer only.
> 
>    To get all direct owner of an extent, it will needs multiple lookup
>    in the reserved mapping tree.
> 
>    And obviously, btrfs is using this method.
> 
>    Pros:
>    *FAST* owner inheritance, which means snapshot creation.
>    (Well, the only advantage I can think of)
> 
>    Cons:
>    *VERY SLOW* backref walk, used by extent deletion, relocation, qgroup
>    and Cow condition check.
>    (That may also be why btrfs default to CoW data, so that it can skip
>     the costy backref walk)
> 
> And a more detailed example of the difference between them will be:
> 
> [Basic tree layout]
>                              Tree X
>                              node A
>                            /        \
>                         node B         node C
>                         /     \       /      \
>                      leaf D  leaf E  leaf F  leaf G
> 
> Use above tree X as snapshot source.
> 
> [Snapshot creation: Direct mapping]
> Then for direct mapping record, if we are going to create snapshot Y
> then we would get:
> 
>             Tree X      Tree Y
>             node A     <node H>
>              |      \ /     |
>              |       X      |
>              |      / \     |
>             node B      node C
>          /      \          /     \
>       leaf D  leaf E   leaf F   leaf G
> 
> We need to create new node H, and update the owner for node B/C/D/E/F/G.
> 
> That's to say, we need to create 1 new node, and update 6 references of
> existing nodes/leaves.
> And this will grow rapidly if the tree is large, but still should be a
> linear increase.
> 
> 
> [Snapshot creation: Indirect mapping]
> And if using indirect mapping tree, firstly, reserved mapping tree
> doesn't record exactly the owner for each leaf/node, but only records
> its parent(s).
> 
> So even when tree X exists along, without snapshot Y, if we need to know
> the owner of leaf D, we only knows its only parent is node B.
> And do the same query on node B until we read node A and knows it's
> owned by tree X.
> 
>                              Tree X         ^
>                              node A         ^ Look upward until
>                            /                | we reach tree root
>                         node B              | to search the owner
>                         /                   | of a leaf/node
>                      leaf D                 |
> 
> So even in its best case, to look up the owner of leaf D, we need to do
> 3 times lookup. One for leaf D, one for node B, one for node A (which is
> the end).
> Such lookup will get more and more complex if there are extra branch in
> the lookup chain.
> 
> But such complicated design makes one thing easier, that is snapshot
> creation:
>             Tree X      Tree Y
>             node A     <node H>
>              |      \ /     |
>              |       X      |
>              |      / \     |
>             node B      node C
>          /      \          /     \
>       leaf D  leaf E   leaf F   leaf G
> 
> Still same tree Y, snapshot from tree X.
> 
> Despite the new node H, we only needs to update the reference lookup for
> node B and C.
> 
> So far so good, as for indirect mapping, we reduced the modification to
> reserved mapping tree, from 6 to 2.
> And it reduce will be even more obvious if the tree is larger.
> 
> But the problem is reserved for snapshot deletion:
> 
> [Snapshot deletion: Direct mapping]
> 
> To delete snapshot Y:
> 
>             Tree X      Tree Y
>             node A     <node H>
>              |      \ /     |
>              |       X      |
>              |      / \     |
>             node B      node C
>          /      \          /     \
>       leaf D  leaf E   leaf F   leaf G
> 
> [Snapshot deletion: Direct mapping]
> Quite straightforward, just check the owner of each node to see if we
> can delete the node/leaf.
> 
> For direct mapping, we just do the owner lookup in the reserved mapping
> tree, 7 times. And we found node H can be deleted.
> 
> That's all, same amount of work for snapshot creation and deletion.
> Not bad.
> 
> [Snapshot deletion: Indirect mapping]
> Here we still needs to the lookup, 7 times.
> 
> But the difference is, each lookup can cause extra lookup.
> 
> For node H, just one single lookup as it's the root.
> But for leaf G, it needs 4 times lookup.
>             Tree X      Tree Y
>             node A     <node H>
>                     \       |
>                      \      |
>                       \     |
>                         node C
>                              |
>                         leaf G
> 
> One for leaf G itself, one for node C, one for node A (parent of node C)
> and one for node H (parent of node C again).
> 
> When summing up the lookup, for indirect mapping it needs:
> 1 for node H
> 3 for node B and C each
> 4 for leaf D~G each
> 
> total 23 lookup opeartions.
> 
> And it will just be even more if there are more snapshots, and it's not
> a linear increase.
> 
> 
> Although we could do some optimization, for example for above extent
> deletion, we don't really care all the owners of the node/leaf, but only
> cares if the extent is shared.
> 
> In that case, if we find node C is also shared by tree X, we don't need
> to check node H.
> If using this optimization, the lookup times reduced to 17 times.
> 
> 
> But here comes to qgroup and balance, where they can't use such
> optimization, as they needs to update all owners to handle the owner
> change. (tree relocation tree for relocation, and qgroup number change
> for quota).
> 
> That's why quota brings an obvious impact on performance.
> 
> 
> So in short conclusions:
> 1) Snapshot is not an easy workload to be considered as one single
>    operation
>    Creation and deletion are different workload, at least for btrfs.
> 
> 2) Snapshot deletion and qgroup is the biggest cost, by the btrfs design
>    Either reduce number of snapshots to reduce branches, or disable
>    quota to optimize the lookup operation.
> 
> Thanks,
> Qu
> 
> 
> > 
> > The 2007 and 2013 Rodeh papers don't do the thorough practical snapshot
> > performance analysis I would expect to see given the assertions in the
> > latter that "BTRFS...supports efficient snapshots..."  The former is
> > sufficiently pre-BTRFS that while it does performance analysis of btree
> > clones, it's unclear (to me at least) if the results can be
> > forward-propagated in some way to real-world performance expectations
> > for BTRFS snapshot creation/deletion/modification.
> > 
> > Has this analysis been performed somewhere else and I'm just missing it?
> >  Also, I'll be glad to comment on my specific setup, kernel version,
> > etc, and discuss pragmatic work-arounds, but I'd like to better
> > understand the high-level performance implications first.
> > 
> > Thanks in advance to anyone who can comment on this.  I am very inclined
> > to read anything thrown at me, so if there is documentation I failed to
> > read, please just send the link.
> > 
> > Best,
> > 
> > ellis
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



