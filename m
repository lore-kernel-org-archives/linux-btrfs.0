Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44460 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753953AbcARLCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 06:02:40 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: "'Chris Mason'" <clm@fb.com>, "'btrfs'" <linux-btrfs@vger.kernel.org>
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com> <20160114141710.GW4227@twin.jikos.cz> <01e901d14f79$a4adb660$ee092320$@cn.fujitsu.com> <20160115164943.GF4227@twin.jikos.cz>
In-Reply-To: <20160115164943.GF4227@twin.jikos.cz>
Subject: RE: [GIT PULL] Fujitsu for 4.5
Date: Mon, 18 Jan 2016 19:02:27 +0800
Message-ID: <020901d151df$b81250e0$2836f2a0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Saturday, January 16, 2016 12:50 AM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: dsterba@suse.cz; 'Chris Mason' <clm@fb.com>; 'btrfs'
> <linux-btrfs@vger.kernel.org>
> Subject: Re: [GIT PULL] Fujitsu for 4.5
> 
> On Fri, Jan 15, 2016 at 05:46:42PM +0800, Zhao Lei wrote:
> > And following 3 patchs in this branch are also for readahead, but
> > sorry that I forgot adding "reada" prefix in subject.
> >   btrfs: Fix in-segment calculation for reada
> >   btrfs: reduce additional fs_info->reada_lock in reada_find_zone
> >   btrfs: Add missed segment checking in reada_find_zone
> >
> > Would you please consider helping me to review them?
> 
> All three reviewed and look ok, but the changelogs could be improved, eg. what
> are the implications of missing the zones etc.

Thanks for review.
I'll update changelogs in the tree.

Thanks
Zhaolei



