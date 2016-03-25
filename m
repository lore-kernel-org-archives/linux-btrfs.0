Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27202 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbcCYSuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 14:50:08 -0400
Date: Fri, 25 Mar 2016 14:49:58 -0400
From: Chris Mason <clm@fb.com>
To: Filipe Manana <fdmanana@kernel.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <miklos@szeredi.hu>
Subject: Re: [PATCH] Btrfs: fix crash/invalid memory access on fsync when
 using overlayfs
Message-ID: <20160325184958.pk23fotivrbhteeg@floor.thefacebook.com>
References: <1458581924-18589-1-git-send-email-fdmanana@kernel.org>
 <20160321175107.rseoedz5yw6ckb3q@floor.thefacebook.com>
 <CAL3q7H4xujc7X4pPySHd_YCM50xfMZuwBH24E-0t0rdi-h9enA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAL3q7H4xujc7X4pPySHd_YCM50xfMZuwBH24E-0t0rdi-h9enA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 05:52:44PM +0000, Filipe Manana wrote:
> On Mon, Mar 21, 2016 at 5:51 PM, Chris Mason <clm@fb.com> wrote:
> > On Mon, Mar 21, 2016 at 05:38:44PM +0000, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> If the lower or upper directory of an overlayfs mount belong to a btrfs
> >> file system and we fsync the file through the overlayfs' merged directory
> >> we ended up accessing an inode that didn't belong to btrfs as if it were
> >> a btrfs inode at btrfs_sync_file() resulting in a crash like the following:
> >
> > Thanks Filipe, I'll put this in a second pull this week, even if its the
> > only patch in it ;)
> 
> Well we need to wait for Miklos patch to be merged first.

I'll cut this one on top of rc1 in a dedicated branch instead.  That way
people can still use the rest of our btrfs pull against v4.5

-chris
