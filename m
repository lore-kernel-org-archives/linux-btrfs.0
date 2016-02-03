Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38358 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932775AbcBCXuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Feb 2016 18:50:40 -0500
Date: Wed, 3 Feb 2016 18:50:32 -0500
From: Chris Mason <clm@fb.com>
To: Filipe Manana <fdmanana@kernel.org>
CC: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix hang on extent buffer lock caused by the
 inode_paths ioctl
Message-ID: <20160203235032.bq6iamhdiifz7ziw@floor.thefacebook.com>
References: <1454531210-7629-1-git-send-email-fdmanana@kernel.org>
 <20160203231941.GA13006@localhost.localdomain>
 <CAL3q7H7N=Fe=QFEr2U2qFPFzwDEGPneVOy_ez_x7B1t3oXzK8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAL3q7H7N=Fe=QFEr2U2qFPFzwDEGPneVOy_ez_x7B1t3oXzK8g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 03, 2016 at 11:24:33PM +0000, Filipe Manana wrote:
> On Wed, Feb 3, 2016 at 11:19 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Wed, Feb 03, 2016 at 08:26:50PM +0000, fdmanana@kernel.org wrote:
> >> So fix this by avoiding doing the nested read lock, which is easily
> >> avoidable. This issue does not happen if task B calls write_lock() after
> >> task A does the second call to read_lock(), however there does not seem
> >> to exist anything in the documentation that mentions what is the expected
> >> behaviour for recursive locking of rwlocks (leaving the idea that doing
> >> so is not a good usage of rwlocks).
> >
> > iterate_inode_refs() does it in anothe way, it's using
> > btrfs_clone_extent_buffer() to keep btrfs from similar deadlock,
> 
> Yeah, I know, I made that fix long time ago.
> 
> > it creates a clone so we don't have trouble on the original eb's read
> > lock, it's more reasonable to me.
> 
> Here it would be overkill to do similar approach, and it's a different
> problem, we're not attempting to lock one leaf while having some other
> leaf locked. We just want to transition a lock from spinning to
> blocking mode - so it was silly to double read lock, we can do
> directly the transition and make sure the release path call below
> doesn't release the leaf. No need to waste memory and time cloning a
> leaf.

Yeah, this is just like unlock_up(), we just want to keep this one
extent buffer locked.  Filipe's patch should be fine.

-chris
