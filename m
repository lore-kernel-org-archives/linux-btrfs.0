Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:4180 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754200Ab3KZSKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 13:10:45 -0500
Message-ID: <5294E42A.4000300@shiftmail.org>
Date: Tue, 26 Nov 2013 19:10:50 +0100
From: joystick <joystick@shiftmail.org>
MIME-Version: 1.0
To: David Brown <david.brown@hesbynett.no>
CC: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131119181237.GA3666@lazy.lzy> <528C9297.9030801@hesbynett.no> <20131120215939.GA2622@lazy.lzy> <528DDCC9.7050701@hesbynett.no> <20131121200545.GB1916@lazy.lzy> <528E6DB2.6050005@hesbynett.no>
In-Reply-To: <528E6DB2.6050005@hesbynett.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/2013 21:31, David Brown wrote:
> On 21/11/13 21:05, Piergiorgio Sartor wrote:
>> Having a multi parity RAID allows to check
>> even which disk.
>> This would provide the user with a more
>> comprehensive (I forgot the spelling)
>> information.
>>
>> Of course, since we are there, we can
>> also give the option to fix it.
>> This would be much likely a "fsck".
> If this can all be done to give the user an informed choice, then it
> sounds good.
>
> One issue here is whether the check should be done with the filesystem
> mounted and in use, or only off-line.  If it is off-line then it will
> mean a long down-time while the array is checked - but if it is online,
> then there is the risk of confusing the filesystem and caches by
> changing the data.
>

Non-existent issue imho, because if that stripe is changing, any error 
will be corrected (overwritten), at least on the data disks (parity can 
still be wrong if a shortcut-rmw method is used).
So you perform fsck for filesystem and data comes out good because any 
error has been overwritten already, and fsck also returns noerror. Not 
useful.

You have to consider only the case where the array check is performed 
online, and the stripe does not change in the meanwhile, that means it 
does not change for a long time, enough for you to complete all the checks.

debugfs techniques can tell you what filesystem element corresponds to a 
certain block number, and this can be done online, with the filesystem 
mounted.

I don't understand the thing you say about the caches. Caches are not an 
obstacle for current "check" operation, so they also won't be a problem 
for the new improved check operation which you are discussing.




