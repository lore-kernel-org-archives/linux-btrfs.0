Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41301 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750769AbdEBPXA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:23:00 -0400
Date: Tue, 2 May 2017 17:22:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: Fix heap use after free.
Message-ID: <20170502152253.GL23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170502062619.497-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502062619.497-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 02:26:19PM +0800, Su Yue wrote:
> The repair_inode_backrefs use the backref again after free while iterating over backrefs.
> So let it continue to next step after free can fix it.

Please enhance the changelog. I'm missing some explanation that the new
code is still correct. I can find that out from code after a while but I
need to compare my findings with yours. It's for documentation and also
to make sure we both agree on the proposed way to fix it.
