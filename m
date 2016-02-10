Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbcBJKN6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 05:13:58 -0500
Date: Wed, 10 Feb 2016 11:13:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "'Chris Mason'" <clm@fb.com>, "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fujitsu for 4.5
Message-ID: <20160210101336.GB30511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <01ad01d14de4$b9489900$2bd9cb00$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 05:28:12PM +0800, Zhao Lei wrote:
> This is collection of some bug fix, enhance and cleanup from fujitsu
> against btrfs for v4.5, mainly for reada, plus some small fix and cleanup
> for scrub and raid56.
> 
> All patchs are in btrfs-maillist, rebased on top of integration-4.5.

I was trying to isolate safe fixes for 4.5 but saw hangs (same as Chris
reported) and was not able to find the right followups.

Can you please collect all your readahead patches sent recently? I got
lost. Make it a git branch and let me know, I'll add it to for-next and
send pull request for 4.6 later.
