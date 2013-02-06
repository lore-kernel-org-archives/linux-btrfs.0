Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46612 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3BFPP3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 10:15:29 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C139B9A03E1
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Feb 2013 08:15:28 -0700 (MST)
Date: Wed, 6 Feb 2013 10:15:26 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marguerite Su <i@marguerite.su>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: Error removing orphan entry, stopping orphan cleanup.
 could not do orphan cleanup -22
Message-ID: <20130206151526.GF26092@localhost.localdomain>
References: <CAK0PdAkGdGWg8TzrDK0hRgcrqqkTF7XrcOHX2wh_7DLG3G0CLA@mail.gmail.com>
 <20130205193549.GC26092@localhost.localdomain>
 <CAK0PdAmnZgE2+nRzrrK_FLa1xcpZPLHyUN69Kx7W5rRVV2bvTA@mail.gmail.com>
 <20130205204523.GD26092@localhost.localdomain>
 <CAK0PdAnMr20LgPriUz40YPg+uu08xqabE25Bh7W_h-Tzq+LEbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAK0PdAnMr20LgPriUz40YPg+uu08xqabE25Bh7W_h-Tzq+LEbA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 06, 2013 at 06:03:14AM -0700, Marguerite Su wrote:
> On Wed, Feb 6, 2013 at 4:45 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> > Ok so I think we've fixed this already, can you build btrfs-next and try
> > mounting with that and see if it fixes the problem?  Thanks,
> 
> Hi, Josef,
> 
> Is there any btrfs git compatible with kernel 3.7 and absorbs this
> fix? So I can dkms it, I'm using openSUSE 12.3 Beta1 with kernel 3.7,
> I can update to 3.8, but next time I do system update to RC1 it will
> fallback to 3.7 again.
> 
> #btrfs-next seems to move forward to 3.8. /uapi/linux/btrfs.h doesn't
> exist in kernel 3.7, it still use the old ioctl.h, I tried to revert
> the ioctl.h > btrfs.h patch, but there's still errors about:
> 
> /usr/src/linux-3.7.1-1/include/trace/events/btrfs.h: In function
> ‘ftrace_raw_event_btrfs_transaction_commit’:
> /usr/src/linux-3.7.1-1/include/trace/events/btrfs.h:61:1: error:
> incompatible types when assigning to type ‘u64’ from type ‘atomic64_t’
> 

Btrfs-next is based on 3.7, you should be able to just git diff v3.7.. >
whatever.patch and get all the changes you need.  Thanks,

Josef
