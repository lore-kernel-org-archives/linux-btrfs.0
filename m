Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:57887 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETLM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 07:12:29 -0400
Received: by mail-ve0-f175.google.com with SMTP id jw12so371289veb.20
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 04:12:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <537A80B6.9080202@gmail.com>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
 <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com>
 <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com>
 <537A2AD5.9050507@swiftspirit.co.za> <20140519173854.GN27178@wotan.suse.de> <537A80B6.9080202@gmail.com>
From: Scott Middleton <scott@assuretek.com.au>
Date: Tue, 20 May 2014 19:12:08 +0800
Message-ID: <CAPm-YUXd8PSfSBqNswj9i-HrjtFb8v-y8qV4MZ=qJiMYgsxNBA@mail.gmail.com>
Subject: Re: send/receive and bedup
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 May 2014 06:07, Konstantinos Skarlatos <k.skarlatos@gmail.com> wrote:
> On 19/5/2014 8:38 μμ, Mark Fasheh wrote:
>>
>
>
> Well, after having good results with duperemove with a few gigs of data, i
> tried it on a 500gb subvolume. After it scanned all files, it is stuck at
> 100% of one cpu core for about 5 hours, and still hasn't done any deduping.
> My cpu is an Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz, so i guess thats not
> the problem. So I guess the speed of duperemove drops dramatically as data
> volume increases.
>
>>
>> There's a TODO list which gives a decent idea of what's on my mind for
>> possible future improvements. I think what I'm most wanting to do right
>> now
>> is some sort of (optional) writeout to a file of what was done during a
>> run.
>> The idea is that you could feed that data back to duperemove to improve
>> the
>> speed of subsequent runs. My priorities may change depending on feedback
>> from users of course.
>>
>> I also at some point want to rewrite some of the duplicate extent finding
>> code as it got messy and could be a bit faster.
>>         --Mark

I'm glad about this discussion.

While I am no where near an expert on file systems, my knowledge has
increased a lot through BtrFS.

ZFS uses RAM to store its checksum tables. Opendedup recommends a
separate HDD. Opendedup uses 4k block sizes. Both are always on.

I'm not against using a separate HDD to store csums. Cheaper than RAM,
albeit slower.

The part of duperemove I like is the ability to CHOOSE when and how I
want to dedupe.

Scott
