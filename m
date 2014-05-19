Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbaESRi6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:38:58 -0400
Date: Mon, 19 May 2014 10:38:54 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
Message-ID: <20140519173854.GN27178@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537A2AD5.9050507@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 19, 2014 at 06:01:25PM +0200, Brendan Hide wrote:
> On 19/05/14 15:00, Scott Middleton wrote:
>> On 19 May 2014 09:07, Marc MERLIN <marc@merlins.org> wrote:
>> Thanks for that.
>>
>> I may be  completely wrong in my approach.
>>
>> I am not looking for a file level comparison. Bedup worked fine for
>> that. I have a lot of virtual images and shadow protect images where
>> only a few megabytes may be the difference. So a file level hash and
>> comparison doesn't really achieve my goals.
>>
>> I thought duperemove may be on a lower level.
>>
>> https://github.com/markfasheh/duperemove
>>
>> "Duperemove is a simple tool for finding duplicated extents and
>> submitting them for deduplication. When given a list of files it will
>> hash their contents on a block by block basis and compare those hashes
>> to each other, finding and categorizing extents that match each
>> other. When given the -d option, duperemove will submit those
>> extents for deduplication using the btrfs-extent-same ioctl."
>>
>> It defaults to 128k but you can make it smaller.
>>
>> I hit a hurdle though. The 3TB HDD  I used seemed OK when I did a long
>> SMART test but seems to die every few hours. Admittedly it was part of
>> a failed mdadm RAID array that I pulled out of a clients machine.
>>
>> The only other copy I have of the data is the original mdadm array
>> that was recently replaced with a new server, so I am loathe to use
>> that HDD yet. At least for another couple of weeks!
>>
>>
>> I am still hopeful duperemove will work.
> Duperemove does look exactly like what you are looking for. The last 
> traffic on the mailing list regarding that was in August last year. It 
> looks like it was pulled into the main kernel repository on September 1st.

I'm confused - you need to avoid a file scan completely? Duperemove does do
that just to be clear.

In your mind, what would be the alternative to that sort of a scan?

By the way, if you know exactly where the changes are you
could just feed the duplicate extents directly to the ioctl via a script. I
have a small tool in the duperemove repositry that can do that for you
('make btrfs-extent-same').


> The last commit to the duperemove application was on April 20th this year. 
> Maybe Mark (cc'd) can provide further insight on its current status.

Duperemove will be shipping as supported software in a major SUSE release so
it will be bug fixed, etc as you would expect. At the moment I'm very busy
trying to fix qgroup bugs so I haven't had much time to add features, or
handle external bug reports, etc. Also I'm not very good at advertising my
software which would be why it hasn't really been mentioned on list lately
:)

I would say that state that it's in is that I've gotten the feature set to a
point which feels reasonable, and I've fixed enough bugs that I'd appreciate
folks giving it a spin and providing reasonable feedback.

There's a TODO list which gives a decent idea of what's on my mind for
possible future improvements. I think what I'm most wanting to do right now
is some sort of (optional) writeout to a file of what was done during a run.
The idea is that you could feed that data back to duperemove to improve the
speed of subsequent runs. My priorities may change depending on feedback
from users of course.

I also at some point want to rewrite some of the duplicate extent finding
code as it got messy and could be a bit faster.
	--Mark

--
Mark Fasheh
