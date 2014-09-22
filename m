Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbaIVNZ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 09:25:29 -0400
Date: Mon, 22 Sep 2014 15:25:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
Message-ID: <20140922132526.GO9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411129114.1811.7.camel@zarniwoop.blob>
 <pan.2014.09.19.13.34.38@googlemail.com>
 <20140922115903.GJ9715@twin.jikos.cz>
 <pan.2014.09.22.12.37.58@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.09.22.12.37.58@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 22, 2014 at 12:37:59PM +0000, Holger Hoffstätte wrote:
> Thanks Dave - that confirms everything I (unscientifically ;) observed so
> far, since I also tried to use "find" to warm up (in the hope it would
> cache the relevant metadata blocks), but running with strace showed that
> it does - of course! - not call stat on each inode, and just quickly reads
> the directory entry list (via getdents()).
> 
> This meant that even after a full "find" a subsequent "du" would still be
> slow(er). Both the cold "find" and a cold "du" also *sound* noticeably
> different, in terms of disk head scratching; find is significantly less
> seeky.

The default find still calls some variant of stat quite a lot because it
needs to decide whether to recurse to the directories, but when compared
to 'du -s' it's still not called for all files.

> Interesting that you also mention the readahead. I've run the "du" warmup
> under Brendan Gregg's iosnoop and it shows that most stat()-heavy I/O is
> done in 16k blocks, while ext4 only seems to use 4k.

Most probably, 16k is the size of the metadata blocks, mkfs option
--nodesize or default since progs v3.12.
