Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38317 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbbCZLQc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 07:16:32 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 26 Mar 2015 21:16:29 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fdmanana@gmail.com
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Subject: Re: [RFC PATCH] btrfs/052: Fix test case to work on variable block size.
Date: Thu, 26 Mar 2015 16:45:35 +0530
Message-ID: <2036702.tCVM0VzSki@localhost.localdomain>
In-Reply-To: <CAL3q7H5Nhzyii3PkYAas+Fe6iQWrunRh_XRa6D8Pazt9MwdoyQ@mail.gmail.com>
References: <1427360830-6209-1-git-send-email-chandan@linux.vnet.ibm.com> <CAL3q7H5Nhzyii3PkYAas+Fe6iQWrunRh_XRa6D8Pazt9MwdoyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Filipe,

On Thursday 26 Mar 2015 10:59:28 Filipe David Manana wrote:
> On Thu, Mar 26, 2015 at 9:07 AM, Chandan Rajendra
> 
> <chandan@linux.vnet.ibm.com> wrote:
> > The test case passes file offsets which are aligned to 4k block size. 
> > This
> > causes btrfs_ioctl_clone() to return with -EINVAL for larger block sizes.
> > Fix this by computing file offsets at run time based on the block size of
> > the underlying filesystem.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > 
> > 
> > 
> > ---
> > There are some more test cases which assume 4k as the underlying
> > filesystem's block size. I am planning to fix them using the
> > final solution agreed upon by the community.
> 
> Seems fine to me. Only one minor comment below.
> You should have mentioned that this patch supersedes your previous
> patch https://patchwork.kernel.org/patch/5908801/

Sorry about that. I will mention this when I post the patchset again and also
put differing messages for the two 'Mismatching hash value' cases.

-- 
chandan

