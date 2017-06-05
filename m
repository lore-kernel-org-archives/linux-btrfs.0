Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56931 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdFEP2B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 11:28:01 -0400
Date: Mon, 5 Jun 2017 17:26:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: use memalloc_nofs and kvzalloc() for free space
 tree bitmaps
Message-ID: <20170605152658.GU12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a8cd2db26fc69434206eecf1846d73d97cd39cfe.1496646708.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a8cd2db26fc69434206eecf1846d73d97cd39cfe.1496646708.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 05, 2017 at 12:12:31AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> First, instead of open-coding the vmalloc() fallback, use the new
> kvzalloc() helper. Second, use memalloc_nofs_{save,restore}() instead of
> GFP_NOFS, as vmalloc() uses some GFP_KERNEL allocations internally which
> could lead to deadlocks.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
