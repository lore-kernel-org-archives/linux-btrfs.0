Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbbIYRkV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 13:40:21 -0400
Date: Fri, 25 Sep 2015 19:39:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Increase running state's priority in stat
 output
Message-ID: <20150925173923.GO11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7c723cfb3f6b2d792b832b96f2b6b0258a13044e.1438070027.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7c723cfb3f6b2d792b832b96f2b6b0258a13044e.1438070027.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 03:53:58PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Anthony Plack <anthony@plack.net> reported a output bug in maillist:
>   title: btrfs-progs SCRUB reporting aborted but still running - minor
> 
> btrfs scrub status report it was aborted but still runs to completion.
>   # btrfs scrub status /mnt/data
>   scrub status for f591ac13-1a69-476d-bd30-346f87a491da
> 	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1089 seconds
> 	total bytes scrubbed: 1.02TiB with 0 errors
>   #
>   # btrfs scrub status /mnt/data
>   scrub status for f591ac13-1a69-476d-bd30-346f87a491da
> 	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1664 seconds
> 	total bytes scrubbed: 1.53TiB with 0 errors
>   #
>   ...
> 
> Reason:
>   When scrub multi-device simultaneously, if some device canceled,
>   and some device is still running, cancel state have higher priority to
>   be outputed in global report.
>   So we can see "scrub aborted" in status line, with running-time keeps
>   increased.
> 
> Fix:
>   We can increase running state's priority in output, if there is
>   some device in scrub state, we output running state instead of
>   cancelled state.
> 
> Reported-by: Anthony Plack <anthony@plack.net>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
