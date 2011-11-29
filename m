Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62300 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab1K2CXf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 21:23:35 -0500
Message-ID: <4ED44297.8080503@cn.fujitsu.com>
Date: Tue, 29 Nov 2011 10:25:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/20] Here's my current btrfs patchset
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexandre Oliva wrote:
> The first 11 patches are relatively simple fixes or improvements that
> I suppose go could make it even in 3.2 (02 is particularly essential
> to avoid progressive performance degradation and metadata space waste
> in the default clustered allocation strategy).
> 

I think 02 (especially!) and 04 are good candidates for 3.2, and others
are all improvements to me, that can wait until next merge window.

> Patch 12 and its complement 15, and also 19, are debugging aids that
> helped me track down the problem fixed in 02.
> 
> Patch 13 is a revised version of the larger-clusters patch I posted
> before, that adds a microoptimization to the bitmap computations to
> the earlier version.
> 
> Patches 14 to 20 are probably not suitable for inclusion, and are
> provided only for reference, although I'm still undecided on 16: it
> seems to me to make sense to stick to the ordered list and index
> instead of jumping to the current cluster's block group, but it may
> also make sense performance-wise to start at the current cluster and
> advance from there.  We still do that, as long as we find a cluster
> to begin with, but I'm yet to double check on the race that causes
> multiple subsequent releases/creation of clusters under heavy load.
> I'm sure I saw it, and I no longer do, but now I'm no longer sure
> whether this is the patch that fixed it, or about the details of how
> we came about that scenario.
> 
> Patches 14, 17, 18 and 20 were posted before, and I'm probably dropping
> them from future patchsets unless I find them to be still useful.
> 
