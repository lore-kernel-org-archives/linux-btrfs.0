Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44599 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752278AbcJKMsd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 08:48:33 -0400
Date: Tue, 11 Oct 2016 14:48:09 +0200
From: David Sterba <dsterba@suse.cz>
To: aron@aron.ws
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: corrupt leaf, slot offset bad
Message-ID: <20161011124809.GN11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57e7870b981160be5fabc63c4967e90f@aron.ws>
 <20161010210346.GA8381@localhost.localdomain>
 <dadc0ef66b1ee3f85446e602ac2e8468@aron.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dadc0ef66b1ee3f85446e602ac2e8468@aron.ws>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

looks like a lot of random bitflips.

On Mon, Oct 10, 2016 at 11:50:14PM +0200, aron@aron.ws wrote:
> item 109 has a few strange chars in its name (and it's truncated): 
> 1-x86_64.pkg.tar.xz 0x62 0x14 0x0a 0x0a
> 
> 	item 105 key (261 DIR_ITEM 54556048) itemoff 11723 itemsize 72
> 		location key (606286 INODE_ITEM 0) type FILE
> 		namelen 42 datalen 0 name: python2-gobject-3.20.1-1-x86_64.pkg.tar.xz
> 	item 106 key (261 DIR_ITEM 56363628) itemoff 11660 itemsize 63
> 		location key (894298 INODE_ITEM 0) type FILE
> 		namelen 33 datalen 0 name: unrar-1:5.4.5-1-x86_64.pkg.tar.xz
> 	item 107 key (261 DIR_ITEM 66963651) itemoff 11600 itemsize 60
> 		location key (1178 INODE_ITEM 0) type FILE
> 		namelen 30 datalen 0 name: glibc-2.23-5-x86_64.pkg.tar.xz
> 	item 108 key (261 DIR_ITEM 68561395) itemoff 11532 itemsize 68
> 		location key (660578 INODE_ITEM 0) type FILE
> 		namelen 38 datalen 0 name: squashfs-tools-4.3-4-x86_64.pkg.tar.xz
> 	item 109 key (261 DIR_ITEM 76859450) itemoff 11483 itemsize 65
> 		location key (2397184 UNKNOWN.0 7091317839824617472) type 45
> 		namelen 13102 datalen 13358 name: 1-x86_64.pkg.tar.xzb

namelen must be smaller than 255, but the number itself does not look
like a bitflip (0x332e), the name looks like a fragment of.

The location key is random garbage, likely an overwritten memory,
7091317839824617472 == 0x62696c0100230000 contains ascii 'bil', the key
type is unknown but should be INODE_ITEM.

> 		data
> 	item 110 key (261 DIR_ITEM 9799832789237604651) itemoff 11405 itemsize 
> 62
> 		location key (388547 INODE_ITEM 0) type FILE
> 		namelen 32 datalen 0 name: intltool-0.51.0-1-any.pkg.tar.xz
> 	item 111 key (261 DIR_ITEM 81211850) itemoff 11344 itemsize 131133

itemsize 131133 == 0x2003d is a clear bitflip, 0x3d == 61, corresponds
to the expected item size.

There's possibly other random bitflips in the keys or other structures.
It's hard to estimate the damage and thus the scope of restorable data.
