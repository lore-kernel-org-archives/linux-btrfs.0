Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbcDDOAZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 10:00:25 -0400
Date: Mon, 4 Apr 2016 15:56:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] delete obsolete function btrfs_print_tree()
Message-ID: <20160404135641.GB3412@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56F550DD.1030200@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56F550DD.1030200@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 03:53:17PM +0100, Holger Hoffstätte wrote:
> Dan Carpenter's static checker recently found missing IS_ERR handling
> in print-tree.c:btrfs_print_tree(). While looking into this I found that
> this function is no longer called anywhere and was moved to btrfs-progs
> long ago. It can simply be removed.

I'm not sure, the function could be used for debugging, and it's hard to
say if we'll ever need it.  Printing the whole tree to the system log
would produce a lot of text so some manual filtering would be required,
the function could serve as a template.

The function is not that big that it would save bytes, but putting it
under the debug config would help a bit.
