Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49653 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933039AbeFUNYS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 09:24:18 -0400
Date: Thu, 21 Jun 2018 15:21:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Three patches that address static analyzer reports
Message-ID: <20180621132126.GN24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180620170333.29182-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180620170333.29182-1-bart.vanassche@wdc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 10:03:30AM -0700, Bart Van Assche wrote:
> Hello Chris and Josef,
> 
> The three patches in this series address complaints reported by static
> analyzers (gcc + W=1, sparse, smatch). These patches do not change any
> functionality. Please consider these for inclusion in the upstream
> kernel.

Applied thanks, with the fixup to patch 3.
