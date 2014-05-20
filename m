Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaETWhG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 18:37:06 -0400
Date: Tue, 20 May 2014 15:37:02 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
Message-ID: <20140520223702.GQ27178@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <20140519173854.GN27178@wotan.suse.de> <537A80B6.9080202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537A80B6.9080202@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 01:07:50AM +0300, Konstantinos Skarlatos wrote:
>> Duperemove will be shipping as supported software in a major SUSE release so
>> it will be bug fixed, etc as you would expect. At the moment I'm very busy
>> trying to fix qgroup bugs so I haven't had much time to add features, or
>> handle external bug reports, etc. Also I'm not very good at advertising my
>> software which would be why it hasn't really been mentioned on list lately
>> :)
>>
>> I would say that state that it's in is that I've gotten the feature set to a
>> point which feels reasonable, and I've fixed enough bugs that I'd appreciate
>> folks giving it a spin and providing reasonable feedback.
> Well, after having good results with duperemove with a few gigs of data, i 
> tried it on a 500gb subvolume. After it scanned all files, it is stuck at 
> 100% of one cpu core for about 5 hours, and still hasn't done any deduping. 
> My cpu is an Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz, so i guess thats 
> not the problem. So I guess the speed of duperemove drops dramatically as 
> data volume increases.

Yeah I doubt it's your CPU. Duperemove is right now targeted at smaller data
sets (a few VMS, iso images, etc) than you threw it at as you undoubtedly
have figured out. It will need a bit of work before it can handle entire
file systems. My guess is that it was spending an enormous amount of time
finding duplicates (it has a very thorough check that could probably be
optimized).

For what it's worth, handling larger data sets is the type of work I want to
be doing on it in the future.
	--Mark

--
Mark Fasheh
