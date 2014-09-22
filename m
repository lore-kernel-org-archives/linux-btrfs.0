Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaIVMiN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 08:38:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XW2se-0001pb-55
	for linux-btrfs@vger.kernel.org; Mon, 22 Sep 2014 14:38:12 +0200
Received: from pd953eb94.dip0.t-ipconnect.de ([217.83.235.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 14:38:12 +0200
Received: from holger.hoffstaette by pd953eb94.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 14:38:12 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Performance Issues
Date: Mon, 22 Sep 2014 12:37:59 +0000 (UTC)
Message-ID: <pan.2014.09.22.12.37.58@googlemail.com>
References: <1411129114.1811.7.camel@zarniwoop.blob>
	<pan.2014.09.19.13.34.38@googlemail.com>
	<20140922115903.GJ9715@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 22 Sep 2014 13:59:03 +0200, David Sterba wrote:

> On Fri, Sep 19, 2014 at 01:34:38PM +0000, Holger Hoffstätte wrote:
>> 
>> I'd also love a technical explanation why this happens and how it could
>> be fixed. Maybe it's just a consequence of how the metadata tree(s)
>> are laid out on disk.
> 
> The stat() call is the most severe slowdown factor in combination with
> fragmentation and random order of the inodes that are being stat()ed.
> 
> A 'ls -f' (that does not stat) goes only through the DIR_INDEX_KEY items
> in the b-tree that are usually packed together and reading is sequential
> and fast.
> 
> A 'ls' that calls stat() in turn will have to seek for the INODE_ITEM
> item that can be far from all the currently read metadata blocks.

Thanks Dave - that confirms everything I (unscientifically ;) observed so
far, since I also tried to use "find" to warm up (in the hope it would
cache the relevant metadata blocks), but running with strace showed that
it does - of course! - not call stat on each inode, and just quickly reads
the directory entry list (via getdents()).

This meant that even after a full "find" a subsequent "du" would still be
slow(er). Both the cold "find" and a cold "du" also *sound* noticeably
different, in terms of disk head scratching; find is significantly less
seeky.

Interesting that you also mention the readahead. I've run the "du" warmup
under Brendan Gregg's iosnoop and it shows that most stat()-heavy I/O is
done in 16k blocks, while ext4 only seems to use 4k.

Time to look at the trees in detail.. :)

-h

