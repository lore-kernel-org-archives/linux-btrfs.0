Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752050AbdFLNk2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 09:40:28 -0400
Date: Mon, 12 Jun 2017 15:39:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, kernel-team@fb.com
Subject: Re: [PATCH 1/7] Btrfs: make add_pinned_bytes() take an s64 num_bytes
 instead of u64
Message-ID: <20170612133922.GL25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496792333.git.osandov@fb.com>
 <c13a2336c1d68648413e7c4beac574999c5d1ba4.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c13a2336c1d68648413e7c4beac574999c5d1ba4.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:26PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> There are a few places where we pass in a negative num_bytes, so make it
> signed for clarity. Also move it up in the file since later patches will
> need it there.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
