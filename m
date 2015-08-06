Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26074 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753833AbbHFCLw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 22:11:52 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
References: <f6eb7359bee352cc27f91d26bcffa6c6f8b1a5fe.1438768766.git.zhaolei@cn.fujitsu.com> <20150805170244.GG31669@twin.jikos.cz>
In-Reply-To: <20150805170244.GG31669@twin.jikos.cz>
Subject: RE: [PATCH 1/3] btrfs: Error handle for get_ref_objectid_v0() in relocate_block_group()
Date: Thu, 6 Aug 2015 10:11:28 +0800
Message-ID: <0b9701d0cfed$34a6a680$9df3f380$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.com]
> Sent: Thursday, August 06, 2015 1:03 AM
> To: Zhao Lei
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 1/3] btrfs: Error handle for get_ref_objectid_v0() in
> relocate_block_group()
> 
> On Wed, Aug 05, 2015 at 06:00:02PM +0800, Zhao Lei wrote:
> > We need error checking code for get_ref_objectid_v0() in
> > relocate_block_group(), to avoid unpredictable result, especially for
> > accessing uninitialized value(when function failed) after this line.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
Thanks for review!

> Are there even filesystems with v0 refs?
Rarely, I think.
(Just a accidental found in debuging another problem)
But for current code, we need hold correct code until
we remove v0 refs support.

Thanks
Zhaolei


