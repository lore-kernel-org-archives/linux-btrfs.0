Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:51555 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbaISRvG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 13:51:06 -0400
Date: Fri, 19 Sep 2014 10:51:04 -0700
From: Zach Brown <zab@zabbo.net>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
Message-ID: <20140919175104.GA920@lenny.home.zabbo.net>
References: <1411129114.1811.7.camel@zarniwoop.blob>
 <pan.2014.09.19.13.51.22@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.09.19.13.51.22@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 19, 2014 at 01:51:22PM +0000, Holger Hoffstätte wrote:
> 
> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
> 
> > I have a particularly uncomplicated setup (a desktop PC with a hard
> > disk) and I'm seeing particularly slow performance from btrfs.  A `git
> > status` in the linux source tree takes about 46 seconds after dropping
> > caches, whereas on other machines using ext4 this takes about 13s.  My
> > mail client (evolution) also seems to perform particularly poorly on
> > this setup, and my hunch is that it's spending a lot of time waiting on
> > the filesystem.
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

There's a lot of meat behind that "just a consequence" but, yes, that's
the heart of it.  Different metadata designs result in different io
patterns which single rotating drives are exquisitely sensitive to.

You can look for differences in io patterns with iostat, blktrace,
iowatcher, etc.  They'll show differences in io sizes, concurrency,
locality, and often differences in the amount of blocks of data read.

  http://masoncoding.com/iowatcher/

As for "fixing it", welllll, it's arguably working as intended.  If you
turned btrfs from one cow tree into lots of journaled trees of trees
then, well, we'd be left with an absurd reimplementation of ext*|xfs.

- z
