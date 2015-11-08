Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:36485 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbbKHVwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Nov 2015 16:52:16 -0500
Date: Mon, 9 Nov 2015 08:51:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Justin Maggard <jmaggard10@gmail.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Subject: Re: [PATCH] btrfs: test quota disable during quota rescan
Message-ID: <20151108215157.GA14311@dastard>
References: <1446835221-11905-1-git-send-email-jmaggard@netgear.com>
 <CAL3q7H6-DatA0-etkVrBjC5EA8n4mtk8oDbo4yG-BnEWUh0KvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6-DatA0-etkVrBjC5EA8n4mtk8oDbo4yG-BnEWUh0KvA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 07, 2015 at 03:08:01PM +0000, Filipe Manana wrote:
> On Fri, Nov 6, 2015 at 6:40 PM, Justin Maggard <jmaggard10@gmail.com> wrote:
> > This test case tests if we are able to disable quotas on a filesystem
> > while a quota rescan is running.  Up to now (4.3) this would result
> > in a kernel NULL pointer dereference.
> >
> > Fixed by patch (btrfs: qgroup: fix quota disable during rescan).
> >
> > Signed-off-by: Justin Maggard <jmaggard@netgear.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Looks good and it triggers the bug without the btrfs kernel fix.
> 
> A side note, and if you would like you could do as a separate patch
> imho, is to speedup creating the files by using multiple
> jobs/processes (as we do in generic/038 for example) - the test takes
> 150 seconds on a debug kernel here, about 130 seconds were spent
> creating the files. Same observation applies to your previous test
> case as well.

Given how many people get such a basic operation "wrong", we need a
helper function for efficiently creating lots of empty files in a
filesystem.

Note that we already have _populate_fs(), but it's not very
efficient when it comes to empty files, nor does it use concurrency.
It seems to me that fixing this function and then using it
everywhere would be the best approach.  Perhaps even doing something
like making fs_mark use deep directory structures, and just calling
it instead to populate the filesystem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
