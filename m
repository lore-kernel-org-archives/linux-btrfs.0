Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58241 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752894AbdFURca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 13:32:30 -0400
Date: Wed, 21 Jun 2017 19:31:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, kernel-team@fb.com
Subject: Re: [PATCH 2/7] Btrfs: make BUG_ON() in add_pinned_bytes() an
 ASSERT()
Message-ID: <20170621173122.GJ21388@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1496792333.git.osandov@fb.com>
 <5e543709c942292f3e97cbd22fd3137dd521bb16.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5e543709c942292f3e97cbd22fd3137dd521bb16.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:27PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Added some changelog.
