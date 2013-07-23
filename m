Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40902 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933722Ab3GWRrp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 13:47:45 -0400
Received: by mail-wg0-f46.google.com with SMTP id k13so699196wgh.13
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 10:47:44 -0700 (PDT)
Message-ID: <51EEC1BD.9030001@gmail.com>
Date: Tue, 23 Jul 2013 19:47:41 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Jerome Haltom <wasabi@cogito.cx>
Subject: Re: Q: Why subvolumes?
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com> <20130723150620.GG20517@carfax.org.uk>
In-Reply-To: <20130723150620.GG20517@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>    Now... since the snapshot's FS tree is a direct duplicate of the
> original FS tree (actually, it's the same tree, but they look like
> different things to the outside world), they share everything --
> including things like inode numbers. This is OK within a subvolume,
> because we have the semantics that subvolumes have their own distinct
> inode-number spaces. If we could snapshot arbitrary subsections of the
> FS, we'd end up having to fix up inode numbers to ensure that they
> were unique -- which can't really be an atomic operation (unless you
> want to have the FS locked while the kernel updates the inodes of the
> billion files you just snapshotted).

I don't think so; I just checked some snapshots and the inos are the same.
Btrfs just changes the dev_id of subvolumes (somehow the vfs allows this).

>    The other thing to talk about here is that while the FS tree is a
> tree structure, it's not a direct one-to-one map to the directory tree
> structure. In fact, it looks more like a list of inodes, in inode
> order, with some extra info for easily tracking through the list. The
> B-tree structure of the FS tree is just a fast indexing method. So
> snapshotting a directory entry within the FS tree would require
> (somehow) making an atomic copy, or CoW copy, of only the parts of the
> FS tree that fall under the directory in question -- so you'd end up
> trying to take a sequence of records in the FS tree, of arbitrary size
> (proportional roughly to the number of entries in the directory) and
> copying them to somewhere else in the same tree in such a way that you
> can automatically dereference the copies when you modify them. So,
> ultimately, it boils down to being able to do CoW operations at the
> byte level, which is going to introduce huge quantities of extra
> metadata, and it all starts looking really awkward to implement (plus
> having to deal with the long time taken to copy the directory entries
> for the thing you're snapshotting).

Btrfs already does CoW of arbitrarily-large files (extent lists);
doing the same for directories doesn't seem impossible.
