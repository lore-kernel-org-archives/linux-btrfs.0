Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53843 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932449AbcFUAzg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 20:55:36 -0400
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <chandan@linux.vnet.ibm.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
 <20160620160354.GR4915@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <91d6f331-14de-5d1b-b73e-c24c0bfe950e@cn.fujitsu.com>
Date: Tue, 21 Jun 2016 08:36:49 +0800
MIME-Version: 1.0
In-Reply-To: <20160620160354.GR4915@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/21/2016 12:03 AM, David Sterba wrote:
> Hi,
>
> I'm looking how well does this patchset merges with the rest, so far
> there are excpected conflicts with Chandan's subpage-blocksize
> patchset. For the easy parts, we can add stub patches to extend
> functions like cow_file_range with parameters that are added by the
> other patch.
>
> Honestly I don't know which patchset to take first. As the
> subpage-blockszie is in the core, there are no user visibility and
> interface questions, but it must not cause any regressions.
>
> Dedupe is optional, not default, and we have to mainly make sure it does
> not have any impact when turned off.
>
> So I see three possible ways:
>
> * merge subpage first, as it defines the API, adapt dedupe

Personally, I'd like to merge subpage first.

AFAIK, it's more important than dedupe.
It affects whether a fs created in 64K page size environment can be 
mounted on a 4K page size system.

And further more, dedupe is still not in the ready-to-be-merged status.

The main undetermined part is ioctl interface.
I'm still working on the state-ful ioctl interface(use -f option to be 
stateless), along with some minor change to allow easy extension.
(To allow user-space caller to know exactly what optional parameter is 
not supported, for later dedeup rate accounting and other things)

And Wang and I are waiting for feedback for V11 patchset.
The latest ENOSPC fix may need another version to address such feedback.

And further more, for dedupe, it's quite easy to avoid any possible 
problem related to sectorsize change.

Just increase minimal dedupe blocksize to maximum sectorsize(64K), then
possible conflicts would be solved.

Thanks,
Qu

> * merge dedupe first, as it only enhanced existing API, adapt subpage
> * create a common branch for both, merge relevant parts of each
>   patchset, add more patches to prepare common ground for either patch
>
> You can deduce yourself which vairant poses work on who. My preference
> is to do the 3rd variant, as it does not force us any particular merge
> order.
>
>


