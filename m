Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbbLGOZF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 09:25:05 -0500
Date: Mon, 7 Dec 2015 15:23:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/12] btrfs: change how delay_iput is tracked in
 btrfs_delalloc_work
Message-ID: <20151207142306.GC4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1449161602.git.dsterba@suse.com>
 <a4469a31e3b0cc55ebba9c3aee26cd5632743056.1449161602.git.dsterba@suse.com>
 <20151204022537.GH19589@localhost.localdomain>
 <20151204123625.GF31035@suse.cz>
 <56618C1F.70805@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56618C1F.70805@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 01:50:39PM +0100, Holger Hoffstätte wrote:
> On 12/04/15 13:36, David Sterba wrote:
> [snip]
> > As the use of the inode pointer is limited, I don't think this would
> > cause surprises. And it's commented where used which should help during
> > debugging.
> 
> When I read through those bits (mostly pondering portability) I was wondering
> whether it might make sense to provide thin wrap/unwrap functions for the tag
> bit instead of relying on open code and comments only.

I'm not sure if a helper makes sense for a single occurence of each
operation, a comment seems enough to me. Anyway, the patch will be
dropped.
