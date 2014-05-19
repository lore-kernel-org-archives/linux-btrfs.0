Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaESRzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:55:32 -0400
Date: Mon, 19 May 2014 10:55:30 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
Message-ID: <20140519175530.GO27178@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <537A3B63.40806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <537A3B63.40806@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 19, 2014 at 08:12:03PM +0300, Konstantinos Skarlatos wrote:
> On 19/5/2014 7:01 μμ, Brendan Hide wrote:
>> On 19/05/14 15:00, Scott Middleton wrote:
>> Duperemove does look exactly like what you are looking for. The last 
>> traffic on the mailing list regarding that was in August last year. It 
>> looks like it was pulled into the main kernel repository on September 1st.
>>
>> The last commit to the duperemove application was on April 20th this year. 
>> Maybe Mark (cc'd) can provide further insight on its current status.
>>
> I have been testing duperemove and it seems to work just fine, in contrast 
> with bedup that i have been unable to install/compile/sort out the mess 
> with python versions. I have 2 questions about duperemove:
> 1) can it use existing filesystem csums instead of calculating its own?

Not right now, though that may be something we can feed to it in the future.

I haven't thought about this much and to be honest I don't recall *exactly*
how btrfs stores it's checksums. That said, I think feasibility of doing
this comes down to a few things:

1) how expensive is it to get at the on-disk checksums?

This might not make sense if it's simply faster to scan a file than its
checksums.


2) are they stored in a manner which makes sense for dedupe.

By that I mean, do we have a checksum for every X bytes? If so, then
theoretically life is easy - we just make our blocksize to X and load the
checksums into duperemoves internal block checksum tree. If checksums can
cover arbitrary sized extents than we might not be able to use them at all
or maybe we would have to 'fill in the blanks' so to speak.


3) what is the tradeoff of false positives?

Btrfs checksums are there for detecting bad blocks, as opposed to duplicate
data. The difference is that btrfs doesn't have to use very strong hashing
as a result. So we just want to make sure that we don't wind up passing
*so* many false positives to the kernel that it was just faster to scan the
file and checksum on our own.


Not that any of those questions are super difficult to answer by the
way, it's more about how much time I've had :)


> 2) can it be included in btrfs-progs so that it becomes a standard feature 
> of btrfs?

I have to think about this one personally as it implies some tradeoffs in my
development on duperemove that I'm not sure I want to make yet.
	--Mark

--
Mark Fasheh
