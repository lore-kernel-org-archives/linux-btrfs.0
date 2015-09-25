Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbbIYQpL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 12:45:11 -0400
Date: Fri, 25 Sep 2015 18:44:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: Modify confuse error message in scrub
Message-ID: <20150925164414.GN11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4779cd8de60a58c7e3d9ea2cf62595bd075638c2.1438830282.git.zhaolei@cn.fujitsu.com>
 <4d18a89d55f130df60c9c604881599172cde0459.1438830282.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d18a89d55f130df60c9c604881599172cde0459.1438830282.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2015 at 11:05:55AM +0800, Zhao Lei wrote:
> Scrub output following error message in my test:
>   ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5 (Success)
> 
> It is caused by a broken kernel and fs, but the we need to avoid
> outputting both "error and success" in oneline message as above.
> 
> This patch modified above message to:
>   ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5, ret=1, errno=0(Success)
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
