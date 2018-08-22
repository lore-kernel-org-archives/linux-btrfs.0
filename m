Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57846 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728057AbeHVQie (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 12:38:34 -0400
Date: Wed, 22 Aug 2018 15:13:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: kill btrfs_clear_path_blocking
Message-ID: <20180822131327.GG24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534888477-15585-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534888477-15585-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 22, 2018 at 05:54:37AM +0800, Liu Bo wrote:
> w/o patch:
> real    2m27.307s
> user    0m12.839s
> sys     13m42.831s
> 
> w/ patch:
> real    1m2.273s
> user    0m15.802s
> sys     8m16.495s

This looks good. The change does not have any potential correctness
problems right? I'm asking if its more or less safe to add it to
for-next now. I have pending cleanups in the extent buffer locking, so I
can finish it and post so the changes are done at once.
