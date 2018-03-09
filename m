Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932206AbeCISQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 13:16:26 -0500
Date: Fri, 9 Mar 2018 19:14:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 06/10] btrfs-progs: kernel-lib: Port kernel sort() to
 btrfs-progs
Message-ID: <20180309181404.GC23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180209074428.29187-1-wqu@suse.com>
 <20180209074428.29187-8-wqu@suse.com>
 <20180221154033.GG1469@twin.jikos.cz>
 <46b36af2-c071-adad-18c0-de4868a4986b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <46b36af2-c071-adad-18c0-de4868a4986b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 09:43:37AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年02月21日 23:40, David Sterba wrote:
> > On Fri, Feb 09, 2018 at 03:44:24PM +0800, Qu Wenruo wrote:
> >> Used by later btrfs_alloc_chunk() rework.
> > 
> > We have the libc provided qsort, so please don't pull another
> > implementation but rather add a wrapper.
> 
> Thanks for pointing this out.
> 
> Another 100 lines saved.
> 
> > 
> >> --- /dev/null
> >> +++ b/kernel-lib/sort.c
> >> @@ -0,0 +1,104 @@
> >> +/*
> >> + * taken from linux kernel lib/sort.c, removed kernel config code and adapted
> >> + * for btrfsprogs
> >> + */
> >> +
> >> +#include "sort.h"
> >> +
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * A fast, small, non-recursive O(nlog n) sort for the Linux kernel
> >> + *
> >> + * Jan 23 2005  Matt Mackall <mpm@selenic.com>
> >> + */
> > 
> > When taking files from kernel: take the file as is and insert notes for
> > btrfs-progs below the comments. The SPDX line must be first.
> 
> Will keep that in mind.
> 
> Although quite a lot of kernel-libs doesn't follow this behavior.
> 
> Maybe we should put some README into kernel-libs/?

This should be a part of development documentation, it's in
Documentation, so far incomplete but adding the 'how to sync shared
kernel code' would be welcome.
