Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbbINUGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 16:06:14 -0400
Date: Mon, 14 Sep 2015 22:05:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/3] btrfs-progs: use calloc instead of malloc+memset
 for tree roots
Message-ID: <20150914200524.GT8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442209006.git.osandov@osandov.com>
 <0ed7db75e4bebd2b538d7c48c9f43c05c9b14f46.1442210847.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0ed7db75e4bebd2b538d7c48c9f43c05c9b14f46.1442210847.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 13, 2015 at 11:08:22PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

I don't know why I missed this patch last time, but now applied to devel
for real.
