Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:34539 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbeHVUmK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 16:42:10 -0400
Date: Wed, 22 Aug 2018 10:16:08 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?=
        <holger@applied-asynchrony.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: kill btrfs_clear_path_blocking
Message-ID: <20180822171607.d7ue3cq4louezvbi@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534888477-15585-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180822131327.GG24025@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180822131327.GG24025@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 22, 2018 at 03:13:28PM +0200, David Sterba wrote:
> On Wed, Aug 22, 2018 at 05:54:37AM +0800, Liu Bo wrote:
> > w/o patch:
> > real    2m27.307s
> > user    0m12.839s
> > sys     13m42.831s
> > 
> > w/ patch:
> > real    1m2.273s
> > user    0m15.802s
> > sys     8m16.495s
> 
> This looks good. The change does not have any potential correctness
> problems right? I'm asking if its more or less safe to add it to
> for-next now. I have pending cleanups in the extent buffer locking, so I
> can finish it and post so the changes are done at once.

Had xfstests run for at least 10 times, without patch 2, I didn't see
any problems related to patch 1.

thanks,
-liubo
