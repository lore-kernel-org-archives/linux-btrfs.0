Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11010 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbcD0TiY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 15:38:24 -0400
Subject: Re: [PATCH 0/8] btrfs: uapi migration for user-visible API components
To: Jeff Mahoney <jeffm@suse.com>,
        Btrfs Development List <linux-btrfs@vger.kernel.org>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <d6511ac6-bcaa-5c14-b802-d3741554cb0f@fb.com>
Date: Wed, 27 Apr 2016 15:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2016 04:14 PM, Jeff Mahoney wrote:
> commit 55e301fd57a (Btrfs: move fs/btrfs/ioctl.h to
> include/uapi/linux/btrfs.h) was intended to make the ioctl definitions
> available to userspace.  Unfortunately, moving just that file wasn't
> enough and many of the ioctls aren't actually usable without the
> userspace programmer filling in the gaps.  Specifically, for the routine
> ioctls like BTRFS_IOC_SETLABEL, BTRFS_LABEL_SIZE wasn't defined so the
> ioctl definition would be incomplete.  We were also missing
> the argument structure for defrag.  Beyond that, many of the ioctl
> structures have a flags field that may or may not be independent of
> the btrfs internals.  Lastly, the SEARCH_TREE ioctl exposes all of the
> internal items of the tree to userspace programmers so the item
> structures should be exposed so that they can be parsed properly.
>
> So, to make all this more convenient for consumers of these APIs, I've
> moved the flags used by the ioctl structures into btrfs.h and
> moved the item definitions, key IDs, tree root objectids, and other
> well-known objectids into a new btrfs_tree.h.  ctree.h includes this
> new header directly, so there aren't any changes to .c files at all.
>
> The only part of this set that isn't just a direct cut-and-paste is
> the last one which converts u8 and u64 values to __u8 and __u64 since
> the former aren't exported via include/uapi.
>
> The goal is that everything required to use the btrfs ioctls for a
> particular kernel release should be made available by exporting the uapi
> headers for that release.
>
> I intend to use these for the strace ioctl decoding patch I've been
> working on so that I don't need to duplicate of the definitions in the
> code I send upstream as the final version of the patch.  Prior to this
> patchset, I had to duplicate nearly 100 defines and several structures --
> and that's without doing any item decoding at all.
>
> I do expect there might be some discussion here. :)
>

Looks fine to me, you can add my

Reviewed-by: Josef Bacik <jbacik@fb.com>

to the whole series.  Thanks,

Josef

