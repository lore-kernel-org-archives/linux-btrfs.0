Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab3HGKkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 06:40:43 -0400
Date: Wed, 7 Aug 2013 12:40:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
Message-ID: <20130807104041.GN5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 06, 2013 at 07:27:20PM +0100, Filipe David Borba Manana wrote:
> This change allows for most mount options to be persisted in
> the filesystem, and be applied when the filesystem is mounted.
> If the same options are specified at mount time, the persisted
> values for those options are ignored.
> 
> The only options not supported are: subvol, subvolid, subvolrootid,
> device and thread_pool. This limitation is due to how this feature
> is implemented: basically there's an optional value (of type
> struct btrfs_dir_item) in the tree of tree roots used to store the
> list of options in the same format as they are passed to btrfs_mount().
> This means any mount option that takes effect before the tree of tree
> roots is setup is not supported.
> 
> To set these options, the user space tool btrfstune was modified
> to persist the list of options into an unmounted filesystem's
> tree of tree roots.

We’ve seen this proposed in the past, IIRC this thread contains most of what
has been discussed:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/19757

Implementing just whole-filesystem mount options is not convering all usecases,
more broad approach like per-subvolume or per-file settings is desired. There
are always settings that aren’t known now but would be useful in the future, so
we need a flexible infrastructure to maintain the properties.

There was a proposed implementation for set/get properties:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/18287

>From the implementation side, I very much want to abandon the separate
btrfstune utility. Currently it’s a bandaid because there’s nothing better atm.

Designing and merging the properties feature takes time, but we want to tune
simple things now. The wiki project mentions ‘tune2fs’ as an example, but the
project details are not always accurate about how to do the things, it’s more
like ideas what to do. If you’re going to work on that, please claim the
project on the wiki, and possibly write more details abou the design.

david
