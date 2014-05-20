Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59127 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaETW46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 18:56:58 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so1003777eek.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 15:56:57 -0700 (PDT)
Message-ID: <537BDDB4.1050406@gmail.com>
Date: Wed, 21 May 2014 01:56:52 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: Brendan Hide <brendan@swiftspirit.co.za>,
        Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <20140519173854.GN27178@wotan.suse.de> <537A80B6.9080202@gmail.com> <20140520223702.GQ27178@wotan.suse.de>
In-Reply-To: <20140520223702.GQ27178@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/5/2014 1:37 πμ, Mark Fasheh wrote:
> On Tue, May 20, 2014 at 01:07:50AM +0300, Konstantinos Skarlatos wrote:
>>> Duperemove will be shipping as supported software in a major SUSE release so
>>> it will be bug fixed, etc as you would expect. At the moment I'm very busy
>>> trying to fix qgroup bugs so I haven't had much time to add features, or
>>> handle external bug reports, etc. Also I'm not very good at advertising my
>>> software which would be why it hasn't really been mentioned on list lately
>>> :)
>>>
>>> I would say that state that it's in is that I've gotten the feature set to a
>>> point which feels reasonable, and I've fixed enough bugs that I'd appreciate
>>> folks giving it a spin and providing reasonable feedback.
>> Well, after having good results with duperemove with a few gigs of data, i
>> tried it on a 500gb subvolume. After it scanned all files, it is stuck at
>> 100% of one cpu core for about 5 hours, and still hasn't done any deduping.
>> My cpu is an Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz, so i guess thats
>> not the problem. So I guess the speed of duperemove drops dramatically as
>> data volume increases.
> Yeah I doubt it's your CPU. Duperemove is right now targeted at smaller data
> sets (a few VMS, iso images, etc) than you threw it at as you undoubtedly
> have figured out. It will need a bit of work before it can handle entire
> file systems. My guess is that it was spending an enormous amount of time
> finding duplicates (it has a very thorough check that could probably be
> optimized).
It finished after 9 or so hours, so I agree it was checking for 
duplicates. It does a few GB in just seconds, so time probably scales 
exponentially with data size.
>
> For what it's worth, handling larger data sets is the type of work I want to
> be doing on it in the future.
I can help with testing :)
I would also suggest that you publish in this list any changes that you 
do, so that your program becomes better known among btrfs users. Or even 
a new announcement mail or a page in the btrfs wiki.

Finally, i would like to request the ability to do file level dedup, 
with a reflink. That has the advantage of consuming very little metadata 
compared to block level dedup. It could be done with a two pass dedup, 
first comparing all the same-sized files and after that doing your 
normal block level dedup.

Btw does anybody have a good program/script that can do file level dedup 
with reflinks and checksum comparison?

Kind regards,
Konstantinos Skarlatos
> 	--Mark
>
> --
> Mark Fasheh

