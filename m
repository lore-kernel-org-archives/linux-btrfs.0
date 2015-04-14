Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbbDNMxb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 08:53:31 -0400
Date: Tue, 14 Apr 2015 14:53:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: directory defrag
Message-ID: <20150414125328.GO25622@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201504140737.17826.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201504140737.17826.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 14, 2015 at 07:37:17AM +0000, Russell Coker wrote:
> The current defragmentation options seem to only support defragmenting named 
> files/directories or a recursive defragmentation of files and directories.
> 
> I'd like to recursively defragment directories.  One of my systems has a large 
> number of large files, the files are write-once and read performance is good 
> enough.  However performance of "ls -al" is often very poor, presumably due to 
> metadata fragmentation.

Ie. the directory metadata in the b-tree. That's possible, but not all
of the code is there. So fare only whole-tree defragmentation is
implemented, ie. the extent tree or any subvolume tree. We'd have to
extend the defrag api to take a key range and then use it to span the
directory key range.
