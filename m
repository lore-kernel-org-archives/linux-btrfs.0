Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbbHKS6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 14:58:43 -0400
Date: Tue, 11 Aug 2015 11:58:42 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: Missing dedupe/locking patch in integration-4.2 tree?
Message-ID: <20150811185842.GN7507@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <55C46842.2000301@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <55C46842.2000301@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 07, 2015 at 10:11:46AM +0200, Holger Hoffstätte wrote:
> 
> Mark's patch titled
> 
>   "[PATCH 3/5] btrfs: fix clone / extent-same deadlocks" [1]
> 
> from his "btrfs: dedupe fixes, features" series is missing from the integration-4.2 tree and 4.2-rc5, where it still applies cleanly (as of 5 mins ago).
> 
> Any particular reason why this was silently dropped?

Same question here, I noticed this shortly after everything went upstream
and was planning a resend but it would be great if you could tell us whether
something was wrong with the patch or if it just got lost in the shuffle (no
big deal).
	--Mark

--
Mark Fasheh
