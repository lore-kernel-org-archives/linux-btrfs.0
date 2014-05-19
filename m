Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-delaine.wadns.net ([196.220.39.203]:25143 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbaESQBn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 12:01:43 -0400
Message-ID: <537A2AD5.9050507@swiftspirit.co.za>
Date: Mon, 19 May 2014 18:01:25 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Scott Middleton <scott@assuretek.com.au>
CC: linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>
Subject: Re: send/receive and bedup
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com>
In-Reply-To: <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/14 15:00, Scott Middleton wrote:
> On 19 May 2014 09:07, Marc MERLIN <marc@merlins.org> wrote:
>> On Wed, May 14, 2014 at 11:36:03PM +0800, Scott Middleton wrote:
>>> I read so much about BtrFS that I mistaked Bedup with Duperemove.
>>> Duperemove is actually what I am testing.
>> I'm currently using programs that find files that are the same, and
>> hardlink them together:
>> http://marc.merlins.org/perso/linux/post_2012-05-01_Handy-tip-to-save-on-inodes-and-disk-space_-finddupes_-fdupes_-and-hardlink_py.html
>>
>> hardlink.py actually seems to be the faster (memory and CPU) one event
>> though it's in python.
>> I can get others to run out of RAM on my 8GB server easily :(

Interesting app.

An issue with hardlinking (with the backups use-case, this problem isn't likely to happen), is that if you modify a file, all the hardlinks get changed along with it - including the ones that you don't want changed.

@Marc: Since you've been using btrfs for a while now I'm sure you've already considered whether or not a reflink copy is the better/worse option.

>>
>> Bedup should be better, but last I tried I couldn't get it to work.
>> It's been updated since then, I just haven't had the chance to try it
>> again since then.
>>
>> Please post what you find out, or if you have a hardlink maker that's
>> better than the ones I found :)
>>
>
> Thanks for that.
>
> I may be  completely wrong in my approach.
>
> I am not looking for a file level comparison. Bedup worked fine for
> that. I have a lot of virtual images and shadow protect images where
> only a few megabytes may be the difference. So a file level hash and
> comparison doesn't really achieve my goals.
>
> I thought duperemove may be on a lower level.
>
> https://github.com/markfasheh/duperemove
>
> "Duperemove is a simple tool for finding duplicated extents and
> submitting them for deduplication. When given a list of files it will
> hash their contents on a block by block basis and compare those hashes
> to each other, finding and categorizing extents that match each
> other. When given the -d option, duperemove will submit those
> extents for deduplication using the btrfs-extent-same ioctl."
>
> It defaults to 128k but you can make it smaller.
>
> I hit a hurdle though. The 3TB HDD  I used seemed OK when I did a long
> SMART test but seems to die every few hours. Admittedly it was part of
> a failed mdadm RAID array that I pulled out of a clients machine.
>
> The only other copy I have of the data is the original mdadm array
> that was recently replaced with a new server, so I am loathe to use
> that HDD yet. At least for another couple of weeks!
>
>
> I am still hopeful duperemove will work.
Duperemove does look exactly like what you are looking for. The last 
traffic on the mailing list regarding that was in August last year. It 
looks like it was pulled into the main kernel repository on September 1st.

The last commit to the duperemove application was on April 20th this 
year. Maybe Mark (cc'd) can provide further insight on its current status.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

