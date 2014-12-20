Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:44111 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbaLTKDt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 05:03:49 -0500
Message-ID: <54954983.3040609@pobox.com>
Date: Sat, 20 Dec 2014 02:03:47 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca>	<5493E8B0.1080107@jp.fujitsu.com> <20141219165849.GA15104@pyropus.ca> <pan$97927$88ff6377$b9b2d72e$d33f9ad1@cox.net>
In-Reply-To: <pan$97927$88ff6377$b9b2d72e$d33f9ad1@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2014 09:33 AM, Duncan wrote:
> Charles Cazabon posted on Fri, 19 Dec 2014 10:58:49 -0600 as excerpted:
>
>> This configuration is one I've been using for many years.  It's only
>> recently that I've noticed it being particularly slow with btrfs -- I
>> don't know if that's because the filesystem has filled up past some
>> critical point, or due to something else entirely.  That's why I'm
>> trying to figure this out.
>
> Not recommending at this point, just saying these are options...
>
> Btrfs raid56 mode should, I believe, be pretty close to done with the
> latest patches.  That would be 3.19, however, which isn't out yet of
> course.

Putting the encryption above the raid is a _huge_ win that he'd lose.

I've used this same layering before (though not with btrfs).

So if you write a sector in this order only one encryption event (e.g. 
"encrypt this sector") has to take place no matter what raid level is in 
place.

If you put the encryption below the raid, then a write or one sector on 
a non-degraded RAID5 requires four encryption events (two decrypts, one 
for the parity and one for the sector being overwritten; followed by two 
encryptions on the same results).

In degraded conditions the profile is much worse.


If encryptions and RAID > 0 is in use, he's better off with what he's 
got in terms of CPU and scheduling.

>
> There's also raid10, if you have enough devices or little enough data to
> do it.  That's much more mature than raid56 mode and should be about as
> mature and stable as btrfs in single-device mode, which is what you are
> using now.  But it'll require more devices than a raid56 would...
>

