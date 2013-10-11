Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab3JKLmd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 07:42:33 -0400
Date: Fri, 11 Oct 2013 13:42:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: improve inode hash function/inode lookup
Message-ID: <20131011114229.GE5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381092807-21422-1-git-send-email-fdmanana@gmail.com>
 <1381094553-2190-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381094553-2190-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 06, 2013 at 10:22:33PM +0100, Filipe David Borba Manana wrote:
> 2) On 32 bits machines. Th VFS hash values are unsigned longs, which
>    are 32 bits wide on 32 bits machines, and the inode (objectid)
>    numbers are 64 bits unsigned integers. We simply cast the inode
>    numbers to hash values, which means that for all inodes with the
>    same 32 bits lower half, the same hash bucket is used for all of
>    them. For example, all inodes with a number (objectid) between
>    0x0000_0000_ffff_ffff and 0xffff_ffff_ffff_ffff will end up in
>    the same hash table bucket.

Well, inode number that does not fit into 32 bits on a 32 bit machine
causes other problems. And subvolume ids that do not fit into 32 bits
cannot be stored in radix tree.

It would be safer to refuse creating/accessing inode/subvolume with
nubmer that does not fit into 32bits.

david
