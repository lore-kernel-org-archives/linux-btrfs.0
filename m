Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751154AbdFBSC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 14:02:29 -0400
Date: Fri, 2 Jun 2017 20:01:27 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] btrfs: check namelen before read name
Message-ID: <20170602180127.GQ12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170602173419.GP12135@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170602173419.GP12135@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 02, 2017 at 07:34:19PM +0200, David Sterba wrote:
> On Thu, Jun 01, 2017 at 04:57:07PM +0800, Su Yue wrote:
> > When reading out name from inode_ref, dir_item, it's possible that
> > corrupted name_len leads to read beyond boundary.
> > Since there are already patches for btrfs-progs, this patchset is
> > for btrfs.
> > 
> > Introduce 'btrfs_is_namelen_valid' to make check namelen with
> > item boundary.
> > If read name from dir_item, use 'verify_dir_item' to do more strict
> > check. Otherwise, use 'btrfs_is_namelen_valid'.
> > 
> > It's unnessary to do check before every read/memcmp_extent_buffer name.
> > Checking namelen when read name for the first time in the call graph is
> > enough.
> > 
> > Changlog:
> > v2:
> > 	1.Change 'btrfs_check_namelen' to 'btrfs_is_namelen_valid'.
> > 	2.Split patches according call graph.
> 
> Now it looks much better, thanks. I briefly went through the patchset
> and checked the callgraphs and haven't spotted any serious problems
> (beyond what's been commented already).
> 
> The changelogs could be improved a bit, and mention how/where the extent
> buffer is read for the first time. For example using btrfs_search_slot,
> or by other means (like iterating leaves).
> 
> One thing that I'd still like to discuss: whether to use namelen or
> name_len.  As name_len matches the member name, I think it should also
> be used in the helper name and subject lines.
> 
> > Su Yue (9):
> >   btrfs: Introduce btrfs_is_namelen_valid to avoid reading beyond
> >     boundary
> >   btrfs: Check namelen with boundary in verify dir_item
> >   btrfs: Check name len on add_inode_ref call path
> >   btrfs: Verify dir_item in 'replay_xattr_deletes'
> >   btrfs: Check namelen in 'btrfs_check_ref_name_override'
> >   btrfs: Check name before read in 'iterate_dir_item'
> >   btrfs: Check namelen before read in 'btrfs_get_name'
> >   btrfs: Check namelen before in 'btrfs_del_root_ref'
> >   btrfs: Verify dir_item 'in iterate_object_props'
> 
> It's not necessary to quote the function in the subject.

As all requested changes do not affect code, I'll add this patchset to
for-next so we whave more test coverage.
