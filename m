Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbbHZRU0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 13:20:26 -0400
Date: Wed, 26 Aug 2015 19:19:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: set error stats when tree block spanning
 stripes
Message-ID: <20150826171949.GA11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <981687019fcca4b4f7455b7a755e48888cbd24ff.1440510311.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <981687019fcca4b4f7455b7a755e48888cbd24ff.1440510311.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 09:45:27PM +0800, Zhao Lei wrote:
> It is better to show error stats to user when we found tree block
> spanning stripes.
> 
> On a btrfs created by old version of btrfs-convert:
> Before patch:
>   # btrfs scrub start -B /dev/vdh
>   scrub done for 8b342d35-2904-41ab-b3cb-2f929709cf47
>           scrub started at Tue Aug 25 21:19:09 2015 and finished after 00:00:00
>           total bytes scrubbed: 53.54MiB with 0 errors
>   # dmesg
>   ...
>   [  128.711434] BTRFS error (device vdh): scrub: tree block 27054080 spanning stripes, ignored. logical=27000832
>   [  128.712744] BTRFS error (device vdh): scrub: tree block 27054080 spanning stripes, ignored. logical=27066368
>   ...
> 
> After patch:
>   # btrfs scrub start -B /dev/vdh
>   scrub done for ff7f844b-7a4e-4b1a-88a9-8252ab25be1b
>           scrub started at Tue Aug 25 21:42:29 2015 and finished after 00:00:00
>           total bytes scrubbed: 53.60MiB with 2 errors
>           error details:
>           corrected errors: 0, uncorrectable errors: 2, unverified errors: 0
>   ERROR: There are uncorrectable errors.

I agree that reporting that is a good thing so the syslog is consistent
with the status output. Is the error really uncorrectable? I'd have to
re-read the reports and root cause analysis again, but can we do it at
least via checker?

The uncorrectable errors are especially worrisome so I'd like to know
what kind of answer should we give.
