Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbbHEQu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 12:50:59 -0400
Date: Wed, 5 Aug 2015 18:50:38 +0200
From: David Sterba <dsterba@suse.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Modify confuse error message in scrub
Message-ID: <20150805165038.GD31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <a2853778dc15eec5eb3b09ddcc3b3e911254c19a.1438763531.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a2853778dc15eec5eb3b09ddcc3b3e911254c19a.1438763531.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 04:32:26PM +0800, Zhao Lei wrote:
> Scrub output following error message in my test:
>   ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5 (Success)
> 
> It is caused by a broken kernel and fs,

In what way is it broken? Can we turn it into tests?

> but the we need to avoid
> outputting both "error and success" in oneline message as above.
> 
> This patch modified above message to:
>   ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5, ret=1, errno=0(Success)

The net effect of the patch is to add ret=.. and errno=.. to the error
message but it also changes a series of ifs to a switch. This belongs to
a separate patch.
