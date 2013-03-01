Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3CAXfv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 18:35:51 -0500
Date: Sat, 2 Mar 2013 00:35:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: try harder to allocate raid56 stripe cache
Message-ID: <20130301233548.GX27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
 <20130301181827.GV1658@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130301181827.GV1658@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 01, 2013 at 10:18:27AM -0800, Zach Brown wrote:
> > -	table = kzalloc(sizeof(*table) + sizeof(*h) * num_entries, GFP_NOFS);
> 
> > +	table = kzalloc(table_size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
> 
> I guess this lost _NOFS on purpose because it was always being done in
> mount?  But if it's done on-demand as Chris wanted it might be called
> from paths that'd need _NOFS again?

Right, then better change it now than to forget to do it later.

david
