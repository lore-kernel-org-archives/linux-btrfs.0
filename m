Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35848 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdFIXpr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 19:45:47 -0400
Received: by mail-pg0-f51.google.com with SMTP id a70so30798283pge.3
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 16:45:46 -0700 (PDT)
Date: Fri, 9 Jun 2017 16:45:44 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 7/7] Btrfs: warn if total_bytes_pinned is non-zero on
 unmount
Message-ID: <20170609234544.GB15078@vader.Home>
References: <cover.1496792333.git.osandov@fb.com>
 <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
 <20170607202204.GD16793@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170607202204.GD16793@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 01:22:04PM -0700, Liu Bo wrote:
> On Tue, Jun 06, 2017 at 04:45:32PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Catch any future/remaining leaks or underflows of total_bytes_pinned.
> >
> 
> This might be a little bit late, what about checking it after
> btrfs_finish_extetn_commit()?
> 
> -liubo

Only reason I didn't put it there was because then I'd have to spend
time to convince myself that it couldn't be modified concurrently :)
I'll try it and make sure. Thanks for the review!
