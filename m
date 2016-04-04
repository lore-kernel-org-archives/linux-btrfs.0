Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49541 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbcDDPyp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 11:54:45 -0400
Subject: Re: [PATCH] delete obsolete function btrfs_print_tree()
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <56F550DD.1030200@googlemail.com>
 <20160404135641.GB3412@twin.jikos.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <57028E42.1090901@googlemail.com>
Date: Mon, 4 Apr 2016 17:54:42 +0200
MIME-Version: 1.0
In-Reply-To: <20160404135641.GB3412@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/04/16 15:56, David Sterba wrote:
> On Fri, Mar 25, 2016 at 03:53:17PM +0100, Holger Hoffstätte wrote:
>> Dan Carpenter's static checker recently found missing IS_ERR handling
>> in print-tree.c:btrfs_print_tree(). While looking into this I found that
>> this function is no longer called anywhere and was moved to btrfs-progs
>> long ago. It can simply be removed.
> 
> I'm not sure, the function could be used for debugging, and it's hard to

..but is it? So far nobody has complained.

> say if we'll ever need it.  Printing the whole tree to the system log
> would produce a lot of text so some manual filtering would be required,
> the function could serve as a template.

The original problem of missing error handling from btrfs_read_tree_block()
remains as well. I don't remember if that also was true for the btrfs-progs
counterpart, but in in any case I didn't really know what to do there.
Print an error? silently ignore the stripe? abort? When I realized that the
function was not called anywhere, deleting it seemed more effective.

Under what circumstances would the in-kernel function be more
practical or useful than the userland tool? It does the same, won't disturb
or wedge the kernel further, is up-to-date and can be scripted.
I agree that in-place filtering (while iterating) would be nice to have,
but that's also a whole different problem and would IMHO also be better
suited for userland.

When in doubt cut it out.

Holger

