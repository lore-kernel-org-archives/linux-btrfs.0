Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbbIVOma (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:42:30 -0400
Date: Tue, 22 Sep 2015 16:41:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] free space B-tree
Message-ID: <20150922144134.GL12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441131625.git.osandov@fb.com>
 <cover.1441309178.git.osandov@fb.com>
 <55F22C89.7060502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55F22C89.7060502@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 11, 2015 at 09:21:13AM +0800, Qu Wenruo wrote:
> Also, it should provide a quite good base for rework inode cache for 
> future development.

You mean what's now under 'inode_cache' mount option? It builds on the
free space cache infrastructure so it would be natural to use it as
well. But still, the usecase for inode_cache is still uncommon.
