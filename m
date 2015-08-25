Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbbHYQZS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 12:25:18 -0400
Date: Tue, 25 Aug 2015 18:24:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, theosib@gmail.com
Subject: Re: [PATCH 1/2] btrfs-progs: Avoid reading bad fd in case of missing
 device.
Message-ID: <20150825162442.GN10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1440127287-21368-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440127287-21368-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21, 2015 at 11:21:26AM +0800, Qu Wenruo wrote:
> Offline btrfs tools, like btrfs-image, will infinitely loop when there
> is missing device.
> 
> The reason is, for missing device, it's fd will be set to -1, but before
> we reading, we only check the fd validation by checking if it's 0.
> So in that case, -1 will pass the validation check, and cause pread to
> return 0, and loop to read.
> 
> Just change the validation check from "== 0" to "<= 0" to avoid such
> problem.
> 
> Reported-by: Timothy Normand Miller <theosib@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks. I'll add a test for that.
