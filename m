Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36215 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751642AbcBOEHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 23:07:08 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: "'Chris Mason'" <clm@fb.com>, "'btrfs'" <linux-btrfs@vger.kernel.org>
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com> <20160210101336.GB30511@twin.jikos.cz>
In-Reply-To: <20160210101336.GB30511@twin.jikos.cz>
Subject: RE: [GIT PULL] Fujitsu for 4.5
Date: Mon, 15 Feb 2016 12:07:01 +0800
Message-ID: <005101d167a6$52b4aea0$f81e0be0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

Thanks for notice me, sorry for reply late.

> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Wednesday, February 10, 2016 6:14 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: 'Chris Mason' <clm@fb.com>; 'btrfs' <linux-btrfs@vger.kernel.org>
> Subject: Re: [GIT PULL] Fujitsu for 4.5
> 
> On Wed, Jan 13, 2016 at 05:28:12PM +0800, Zhao Lei wrote:
> > This is collection of some bug fix, enhance and cleanup from fujitsu
> > against btrfs for v4.5, mainly for reada, plus some small fix and cleanup
> > for scrub and raid56.
> >
> > All patchs are in btrfs-maillist, rebased on top of integration-4.5.
> 
> I was trying to isolate safe fixes for 4.5 but saw hangs (same as Chris
> reported) and was not able to find the right followups.
> 
The problem is discussed in btrfs maillist from:
http://www.spinics.net/lists/linux-btrfs/msg51275.html
to
http://www.spinics.net/lists/linux-btrfs/msg51538.html

It is fixed now.

> Can you please collect all your readahead patches sent recently? I got
> lost. Make it a git branch and let me know, I'll add it to for-next and
> send pull request for 4.6 later.
I collected all reada patchs in:
https://github.com/zhaoleidd/btrfs.git integration-4.5

The description of above branch is this:
http://www.spinics.net/lists/linux-btrfs/msg51531.html

Thanks
Zhaolei



