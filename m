Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaIVL7F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 07:59:05 -0400
Date: Mon, 22 Sep 2014 13:59:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
Message-ID: <20140922115903.GJ9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411129114.1811.7.camel@zarniwoop.blob>
 <pan.2014.09.19.13.34.38@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.09.19.13.34.38@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 19, 2014 at 01:34:38PM +0000, Holger Hoffstätte wrote:
> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
> 
> > I have a particularly uncomplicated setup (a desktop PC with a hard
> > disk) and I'm seeing particularly slow performance from btrfs.  A `git
> > status` in the linux source tree takes about 46 seconds after dropping
> > caches, whereas on other machines using ext4 this takes about 13s.  My
> 
> This is - unfortunately - a particular btrfs oddity/characteristic/flaw,
> whatever you want to call it. git relies a lot on fast stat() calls,
> and those seem to be particularly slow with btrfs esp. on rotational
> media. I have the same problem with rsync on a freshly mounted volume;
> it gets fast (quite so!) after the first run.
> 
> The simplest thing to fix this is a "du -s >/dev/null" to pre-cache all
> file inodes.
> 
> I'd also love a technical explanation why this happens and how it could
> be fixed. Maybe it's just a consequence of how the metadata tree(s)
> are laid out on disk.

The stat() call is the most severe slowdown factor in combination with
fragmentation and random order of the inodes that are being stat()ed.

A 'ls -f' (that does not stat) goes only through the DIR_INDEX_KEY items
in the b-tree that are usually packed together and reading is sequential
and fast.

A 'ls' that calls stat() in turn will have to seek for the INODE_ITEM
item that can be far from all the currently read metadata blocks.

What could help here is a directory readahead, pre-read the inode items
during the readdir() call. I tried this with current readahead (some
timeago) code but this didn't lead to improvement. The reason is that
the readahead has low priority and is not able to cache the metadata
blocks in time.

So the fix or rather workaround is to implement high priority readahead
and trigger it for all DIR_INDEX keys that get returned by readdir().
This will hurt the 'ls -f' usecase.

In your example, 'du -s' acts as the readahead step.
