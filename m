Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaLSRDY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:03:24 -0500
Date: Fri, 19 Dec 2014 18:03:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs-progs: check result of first_cache_extent
Message-ID: <20141219170321.GK27601@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1419005022.git.dsterba@suse.cz>
 <813550c84636f7d570c541c22eee60b11346b4f3.1419005022.git.dsterba@suse.cz>
 <549458C9.2040603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549458C9.2040603@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 19, 2014 at 10:56:41AM -0600, Eric Sandeen wrote:
> On 12/19/14 10:06 AM, David Sterba wrote:
> > If the tree's empty, we'll get NULL and dereference it.
> 
> Hm, but this is under an explicit check for not empty:
> 
>         while (!cache_tree_empty(roots_info_cache)) {
> 
> sooo?  Maybe it's just defensive?  Nothing really wrong
> with being defensive, I suppose, so:

Well, mostly to shut up the warning with a minimal change. It could be
rewritten to

	while ((entry = ...)) { ... }

as in other places.
