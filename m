Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:46963 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeFFJtu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 05:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com>
References: <20180508180436.716-1-mfasheh@suse.de> <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com> <20180509064103.GP10363@dastard>
 <5b2ae799-1595-c262-7b65-41b10c11906d@suse.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Jun 2018 12:49:48 +0300
Message-ID: <CAOQ4uxjUwi7dhTbNk1mK6_=rb_+L0JB1GG_mkGSDrudtocXScg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than one root
To: Jeff Mahoney <jeffm@suse.com>
Cc: Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 5, 2018 at 11:17 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> Sorry, just getting back to this.
>
> On 5/9/18 2:41 AM, Dave Chinner wrote:
>> On Tue, May 08, 2018 at 10:06:44PM -0400, Jeff Mahoney wrote:
>>> On 5/8/18 7:38 PM, Dave Chinner wrote:
>>>> On Tue, May 08, 2018 at 11:03:20AM -0700, Mark Fasheh wrote:
>>>>> Hi,
>>>>>
>>>>> The VFS's super_block covers a variety of filesystem functionality. In
>>>>> particular we have a single structure representing both I/O and
>>>>> namespace domains.
>>>>>
>>>>> There are requirements to de-couple this functionality. For example,
>>>>> filesystems with more than one root (such as btrfs subvolumes) can
>>>>> have multiple inode namespaces. This starts to confuse userspace when
>>>>> it notices multiple inodes with the same inode/device tuple on a
>>>>> filesystem.
>>>>

Speaking as someone who joined this discussion late, maybe years after
it started, it would help to get an overview of existing problems and how
fs_view aims to solve them.

I do believe that both Overlayfs and Btrfs can benefit from a layer of
abstraction
in the VFS, but I think it is best if we start with laying all the
common problems
and then see how a solution would look like.

Even the name of the abstraction (fs_view) doesn't make it clear to me what
it is we are abstracting (security context? st_dev? what else?). probably best
to try to describe the abstraction from user POV rather then give sporadic
examples of what MAY go into fs_view.

While at it, need to see if this discussion has any intersections with David
Howell's fs_context work, because if we consider adding sub volume support
to VFS, we may want to leave some reserved bits in the API for it.

[...]

> One thing is clear: If we want to solve the btrfs and overlayfs problems
> in the same way, the view approach with a simple static mapping doesn't
> work.  Sticking something between the inode and superblock doesn't get
> the job done when the belongs to a different file system.  Overlayfs
> needs a per-object remapper, which means a callback that takes a path.
> Suddenly the way we do things in the SUSE kernel doesn't seem so hacky
> anymore.
>

And what is the SUSE way?

> I'm not sure we need the same solution for btrfs and overlayfs.  It's
> not the same problem.  Every object in overlayfs as a unique mapping
> already.  If we report s_dev and i_ino from the inode, it still maps to
> a unique user-visible object.  It may not map back to the overlayfs
> name, but that's a separate issue that's more difficult to solve.  The
> btrfs issue isn't one of presenting an alternative namespace to the
> user.  Btrfs has multiple internal namespaces and no way to publish them
> to the rest of the kernel.
>

FYI, the Overlayfs file/inode mapping is about to change with many
VFS hacks queued for removal, so stay tuned.

[...]

>> My point is that if we are talking about infrastructure to remap
>> what userspace sees from different mountpoint views into a
>> filesystem, then it should be done above the filesystem layers in
>> the VFS so all filesystems behave the same way. And in this case,
>> the vfsmount maps exactly to the "fs_view" that Mark has proposed we
>> add to the superblock.....
>
> It's proposed to be above the superblock with a default view in the
> superblock.  It would sit between the inode and the superblock so we
> have access to it anywhere we already have an inode.  That's the main
> difference.  We already have the inode everywhere it's needed.  Plumbing
> a vfsmount everywhere needed means changing code that only requires an
> inode and doesn't need a vfsmount.
>
> The two biggest problem areas:
> - Writeback tracepoints print a dev/inode pair.  Do we want to plumb a
> vfsmount into __mark_inode_dirty, super_operations->write_inode,
> __writeback_single_inode, writeback_sb_inodes, etc?
> - Audit.  As it happens, most of audit has a path or file that can be
> used.  We do run into problems with fsnotify.  fsnotify_move is called
> from vfs_rename which turns into a can of worms pretty quickly.
>

Can you please elaborate on that problem.
Do you mean when watching a directory for changes, you need to
be able to tell in which fs_view the directory inode that is being watched?

>>> It makes sense for that to be above the
>>> superblock because the file system doesn't care about them.  We're
>>> interested in the inode namespace, which for every other file system can
>>> be described using an inode and a superblock pair, but btrfs has another
>>> layer in the middle: inode -> btrfs_root -> superblock.
>>
>> Which seems to me to be irrelevant if there's a vfsmount per
>> subvolume that can hold per-subvolume information.
>
> I disagree.  There are a ton of places where we only have access to an
> inode and only need access to an inode.  It also doesn't solve the
> overlayfs issue.
>

I have an interest of solving another problem.
In VFS operations where only inode is available, I would like to be able to
report fsnotify events (e.g. fsnotify_move()) only in directories under a
certain subtree root. That could be achieved either by bind mount the subtree
root and passing vfsmount into vfs_rename() or by defining an fs_view on the
subtree and mounting that fs_view.

Thanks,
Amir.
