Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751116AbdFURlt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 13:41:49 -0400
Date: Wed, 21 Jun 2017 19:40:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, kernel-team@fb.com, jeffm@suse.com
Subject: Re: [PATCH 7/7] Btrfs: warn if total_bytes_pinned is non-zero on
 unmount
Message-ID: <20170621174042.GK21388@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496792333.git.osandov@fb.com>
 <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:32PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Catch any future/remaining leaks or underflows of total_bytes_pinned.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

This patch received some objections. As it's a debugging aid, I'd rather
merge a patch that other agree is useful for that purpose.
