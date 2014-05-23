Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61398 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWPs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 11:48:27 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so3889112eek.9
        for <linux-btrfs@vger.kernel.org>; Fri, 23 May 2014 08:48:26 -0700 (PDT)
Message-ID: <537F6DC4.8000503@gmail.com>
Date: Fri, 23 May 2014 18:48:20 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Mark Fasheh <mfasheh@suse.de>, Brendan Hide <brendan@swiftspirit.co.za>,
        Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <20140519173854.GN27178@wotan.suse.de> <537A80B6.9080202@gmail.com> <20140520223702.GQ27178@wotan.suse.de> <537BDDB4.1050406@gmail.com> <EF03712B-B6C1-4EAA-96CA-44054A706B67@colorremedies.com>
In-Reply-To: <EF03712B-B6C1-4EAA-96CA-44054A706B67@colorremedies.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/5/2014 3:58 πμ, Chris Murphy wrote:
> On May 20, 2014, at 4:56 PM, Konstantinos Skarlatos <k.skarlatos@gmail.com> wrote:
>
>> On 21/5/2014 1:37 πμ, Mark Fasheh wrote:
>>> On Tue, May 20, 2014 at 01:07:50AM +0300, Konstantinos Skarlatos wrote:
>>>>> Duperemove will be shipping as supported software in a major SUSE release so
>>>>> it will be bug fixed, etc as you would expect. At the moment I'm very busy
>>>>> trying to fix qgroup bugs so I haven't had much time to add features, or
>>>>> handle external bug reports, etc. Also I'm not very good at advertising my
>>>>> software which would be why it hasn't really been mentioned on list lately
>>>>> :)
>>>>>
>>>>> I would say that state that it's in is that I've gotten the feature set to a
>>>>> point which feels reasonable, and I've fixed enough bugs that I'd appreciate
>>>>> folks giving it a spin and providing reasonable feedback.
>>>> Well, after having good results with duperemove with a few gigs of data, i
>>>> tried it on a 500gb subvolume. After it scanned all files, it is stuck at
>>>> 100% of one cpu core for about 5 hours, and still hasn't done any deduping.
>>>> My cpu is an Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz, so i guess thats
>>>> not the problem. So I guess the speed of duperemove drops dramatically as
>>>> data volume increases.
>>> Yeah I doubt it's your CPU. Duperemove is right now targeted at smaller data
>>> sets (a few VMS, iso images, etc) than you threw it at as you undoubtedly
>>> have figured out. It will need a bit of work before it can handle entire
>>> file systems. My guess is that it was spending an enormous amount of time
>>> finding duplicates (it has a very thorough check that could probably be
>>> optimized).
>> It finished after 9 or so hours, so I agree it was checking for duplicates. It does a few GB in just seconds, so time probably scales exponentially with data size.
> I'm going to guess it ran out of memory. I wonder what happens if you take an SSD and specify a humongous swap partition on it. Like, 4x, or more, the amount of installed memory.
Just tried it again, with 32GiB swap added on an SSD. My test files are 
633GiB.
duperemove -rv /storage/test 19537.67s user 183.86s system 89% cpu 
6:06:56.96 total

Duperemove was using about 1GiB or RAM, had one core at 100%, and I 
think swap was not touched at all.


>
> This same trick has been mentioned on the XFS list for use with xfsrepair when memory requirements exceed system memory, and is immensely faster.
>
>
> Chris Murphy
>

