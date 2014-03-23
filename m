Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-gabriella.wadns.net ([196.220.39.91]:37988 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbaCWHMz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 03:12:55 -0400
Message-ID: <532E8967.1040400@swiftspirit.co.za>
Date: Sun, 23 Mar 2014 09:12:39 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Send/Receive howto and script for others to use (was Re: Is anyone
 using btrfs send/receive)
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20140107104951.GL10936@merlins.org> <20140107105329.GE15634@carfax.org.uk> <20140108080206.GV10936@merlins.org> <20140321172904.GE28005@merlins.org> <532DE805.7040407@swiftspirit.co.za> <20140322200057.GJ28005@merlins.org> <532DFA60.3030106@swiftspirit.co.za> <20140322211159.GM28005@merlins.org>
In-Reply-To: <20140322211159.GM28005@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/22 11:11 PM, Marc MERLIN wrote:
> Please consider adding a blank line between quotes, it makes them just a bit
> more readable :)

Np.

> On Sat, Mar 22, 2014 at 11:02:24PM +0200, Brendan Hide wrote:
>>> - it doesn't create writeable snapshots on the destination in case you want
>>> to use the copy as a live filesystem
>> One of the issues with doing writeable snapshots by default is that the
>> backup is (ever so slightly) less safe from "fat-finger syndrome". If I
>> want a writeable snapshot, I'll make it from the read-only snapshot,
>> thereby reducing the chances of accidentally "tainting" or deleting data
>> in the backup. I actually *did* accidentally delete my entire filesystem
>> (hence the paranoid umounts). But, of course, my script *first* created
>> read-only snapshots from which recovery took only a few minutes. ;)
> The writeable snapshot I create is on top of the read only one used by btrfs
> receive. So, I can play with it, but it won't upset/break anything for
> the backup.
>
> The historical snapshots I keep give me cheap backups to go back to do get a
> file I may have deleted 3 days ago and want back now even though my btrfs
> send/receive runs hourly.

Ah. In that case my comment is moot. I could add support for something 
like this but I'm unlikely to use it.

> [snip]
>>> - Your comments say shlock isn't safe and that's documented. I don't see
>>> that in the man page
>>> http://manpages.ubuntu.com/manpages/trusty/man1/shlock.1.html
>> That man page looks newer than the one I last looked at - specifically
>> the part saying "improved by Berend Reitsma to solve a race condition."
>> The previous documentation on shlock indicated it was safe for hourly
>> crons - but not in the case where a cron might be executed twice
>> simultaneously. Shlock was recommended by a colleague until I realised
>> this potential issue, thus my template doesn't use it. I should update
>> the comment with some updated information.
> It's not super important, it was more my curiosity.
> If a simple lock program in C isn't atomic, what's the point of it?
> I never looked at the source code, but maybe I should...

Likely the INN devs needed something outside of a shell environment. 
Based on the man page, shlock should be atomic now.

>>> I'd love to have details on this if I shouldn't be using it
>>> - Is set -o noclobber; echo $$ > $lockfile really atomic and safer than
>>> shlock? If so, great, although I would then wonder why shlock even exists
>>> :)
>> The part that brings about an atomic lock is "noclobber", which sets it
>> so that we are not allowed to "clobber"/"overwrite" an existing file.
>> Thus, if the file exists, the command fails. If it successfully creates
>> the new file, the command returns true.
>   
> I understand how it's supposed to work, I just wondered if it was really
> atomic as it should be since there would be no reason for shlock to even
> exist with that line of code you wrote.

When I originally came across the feature I wasn't sure it would work 
and did extensive testing: For example, spawn 30 000 processes, each of 
which tried to take the lock. After the machine became responsive again 
;) only 1 lock ever turned out to have succeeded.

Since then its been in production use across various scripts on hundreds 
of servers. My guess (see above) is that the INN devs couldn't or didn't 
want to use it.

The original page where I learned about noclobber: 
http://www.davidpashley.com/articles/writing-robust-shell-scripts/

> Thanks for the info Marc 

No problem - and thanks. :)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

