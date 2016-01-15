Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbcAOQtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 11:49:46 -0500
Date: Fri, 15 Jan 2016 17:49:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: dsterba@suse.cz, "'Chris Mason'" <clm@fb.com>,
        "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fujitsu for 4.5
Message-ID: <20160115164943.GF4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
 <20160114141710.GW4227@twin.jikos.cz>
 <01e901d14f79$a4adb660$ee092320$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01e901d14f79$a4adb660$ee092320$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 15, 2016 at 05:46:42PM +0800, Zhao Lei wrote:
> And following 3 patchs in this branch are also for readahead, but sorry that
> I forgot adding "reada" prefix in subject.
>   btrfs: Fix in-segment calculation for reada
>   btrfs: reduce additional fs_info->reada_lock in reada_find_zone
>   btrfs: Add missed segment checking in reada_find_zone
> 
> Would you please consider helping me to review them?

All three reviewed and look ok, but the changelogs could be improved,
eg. what are the implications of missing the zones etc.
