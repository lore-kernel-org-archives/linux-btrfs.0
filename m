Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3KWAwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 19:52:46 -0500
Date: Sat, 23 Nov 2013 01:52:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Add support for object properties
Message-ID: <20131123005243.GK5007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 12, 2013 at 01:41:41PM +0000, Filipe David Borba Manana wrote:
> This is a revised version of the original proposal/work from Alexander Block
> to introduce a generic framework to set properties on btrfs filesystem objects
> (inodes, subvolumes, filesystems, devices).

>         Currently the command group looks like this:
>         btrfs prop set [-t <type>] /path/to/object <name> <value>
>         btrfs prop get [-t <type>] /path/to/object [<name>] (omitting name dumps all)
>         btrfs prop list [-t <type>] /path/to/object (lists properties with description)
> 
>         The type is used to explicitly specify what type of object you mean. This is 
>         necessary in case the object+property combination is ambiguous.  For example
>         '/path/to/fs/root' could mean the root subvolume, the directory inode or the 
>         filesystem itself. Normally, btrfs-progs will try to detect the type 
>         automatically.

The generic commandline UI still looks ok to me, storing properties as xattr’s
is also ok (provided that we can capture the “btrfs.” xattr namespace).

I’ll dump my thoughts and questions about the rest.

1) Where are stored properties that are not directly attached to an inode? Ie.
   whole-filesystem and device. How can I access props for a subvolume that is
   not currently reachable in the directory tree?

A fs or device props must be accessible any time, eg. no matter which subvolume
is currently mounted. This should be probably a special case where the property
can be queried from any inode but will be internally routed to eg. toplevel
subvolume that will store the respective xattrs.


2) if a property’s object can be ambiguous, how is that distinguished in the
   xattrs?

We don’t have a list of props yet, so I’m trying to use one that hopefully
makes some sense. The example here can be persistent-mount-options that are
attached to fs and a subvolume. The fs-wide props will apply when a different
subvolume is explicitly mounted.

Assuming that the xattrs are stored with the toplevel subvolume, the fs-wide
and per-subvolume property must have a differnt xattr name (another option is
to store fs-wide elsewhere). So the question is, if we should encode the
property object into the xattr name directly. Eg.:

  btrfs.fs.persistent_mount
  btrfs.subvol.persistent_mount

or if the fs-wide uses a reserved naming scheme that would appear as xattr
named

  btrfs.persistent_mount

but the value would differ if queried with ‘-t fs or ‘-t subvolume’.


3) property precedence, interaction with mount options

The precedence should follow the rule of the least surprise, ie. if I set eg. a
compression of a file to zlib, set the subvolume compression type to ‘none’ and
have fs-wide mount the filesystem with compress=lzo, I’m expecting that the
file will use ‘zlib’.

The generic rule says that mount options (that have a corresponding property)
take precedence. There may be exceptions.

What if there are no specific mount options, but the subvolume has eg.
compression set? Should new files inherit that automatically or only if
explicitly marked as such?

The background concern is how far do I need to look and whether this could be a
potential performance problem. The lookup chain can be long: inode -> dir ->
subvol -> fs, plus mount options along the path where applicable.

If the xattr values are cached in structs that are accessed anyway (containing
subvol, fs_info) and updated when property xattr changes, this could work.


4) behaviour of tools that see the btrfs-specific props

What would cp or rsync do when copying the xattrs to a different filesystem?
They may simply ignore it and just try to copy the user. namespace, I haven’t
done any research here.


5) properties to consider, naming, xattr name namespaces, inheritable props

Here’s a list of properties that I’ve collected so far:

filesystem-wide
- persistent mount options
- default raid allocation profile
- default compression parameters
- label
- scrub ioprio

subvolume
- persistent mount options
- default raid allocation profile
- default compression parameters
- writable

device
- writable/ro/dead
- hot-spare
- preferred for metadata
- preferred data reads
- preferred data writes
- no new allocations if possible
- speed profile, io priorities
- allocation group - from project idea "Chunk allocation groups"
- "ssd cache", L2ARC
- scrub ioprio

file, directory
- compression parameters
- raid allocation profile

details on compression parameters:
- compression algo
- compression level
- desired compression ratio target
- file compressibility hint - from project idea “Compression updates”
- compression container type - dtto

The props should be basically self explanatory. This is not a complete or
finalized list, feel free to suggest what you think should/not be here.

The number of compression parameters suggest that a namespace would be
appropriate. This could establish a common practice for any set of properties
that are not attached to any filesystem object but are grouped logically.

Most of the props are expected to be read-write, I don’t have a counterexample
for a property that makes sense, is persistent and must be read-only. Such one
can be exported through the sysfs, so s/Most of/All/ in the previous sentence.

I don’t have a proposal how to mark inheritable props yet.


david
