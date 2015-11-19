Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36951 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758691AbbKSPBd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 10:01:33 -0500
Date: Thu, 19 Nov 2015 10:01:25 -0500
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, Filipe Manana <fdmanana@gmail.com>,
        Justin Maggard <jmaggard10@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Subject: Re: [PATCH] btrfs: qgroup: fix quota disable during rescan
Message-ID: <20151119150125.GA9887@ret.masoncoding.com>
References: <1446835002-11751-1-git-send-email-jmaggard@netgear.com>
 <20151119130827.GC31035@twin.jikos.cz>
 <CAL3q7H4vJKPKArZL1JWghHQU+JKqgXA8b0C5fr9+19TPHJKH1Q@mail.gmail.com>
 <20151119132047.GD31035@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151119132047.GD31035@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2015 at 02:20:47PM +0100, David Sterba wrote:
> On Thu, Nov 19, 2015 at 01:16:42PM +0000, Filipe Manana wrote:
> > On Thu, Nov 19, 2015 at 1:08 PM, David Sterba <dsterba@suse.cz> wrote:
> > > Hi,
> > >
> > > On Fri, Nov 06, 2015 at 10:36:42AM -0800, Justin Maggard wrote:
> > >> There's a race condition that leads to a NULL pointer dereference if you
> > >> disable quotas while a quota rescan is running.  To fix this, we just need
> > >> to wait for the quota rescan worker to actually exit before tearing down
> > >> the quota structures.
> > >
> > > I see a reproducible crash in btrfs/115 (the fstest for this patch).
> > > This is with 4.4-rc1, so the patch is included:
> > 
> > That's the expected crash, the patch isn't in 4.4-rc1.
> 
> Aha, thanks. I got confused with the other fix, "btrfs: qgroup: exit
> the rescan worker during umount".

Me too, sorry Justin I'll get the other one too.

-chris
