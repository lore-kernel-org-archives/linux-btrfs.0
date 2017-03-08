Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45564 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbdCHMUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 07:20:02 -0500
Date: Wed, 8 Mar 2017 13:18:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>, kernel-team@fb.com
Subject: Re: [PATCH v2] btrfs-progs: report I/O errors when closing the
 filesystem
Message-ID: <20170308121833.GA4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d187bd863a7eacb2172b693a95c6a8b875e144c4.1488560213.git.osandov@fb.com>
 <105e3aa192a47f3936c2ac47ad8d673745cccaea.1488560489.git.osandov@fb.com>
 <ab252cb5-b59e-d445-b69c-0dfe15c0861a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ab252cb5-b59e-d445-b69c-0dfe15c0861a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 08:42:01AM +0800, Qu Wenruo wrote:
> 
> 
> At 03/04/2017 01:02 AM, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> >
> > If the final fsync() on the Btrfs device fails, we just swallow the
> > error and don't alert the user in any way. This was uncovered by xfstest
> > generic/405, which checks that mkfs fails when it encounters EIO.
> >
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> 
> Please ignore my comment on v1 patch, didn't see the v2 one.
> 
> Looks good to me.
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
