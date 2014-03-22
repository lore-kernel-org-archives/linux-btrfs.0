Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-lucinda.wadns.net ([196.220.39.179]:15558 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbaCVVCk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 17:02:40 -0400
Message-ID: <532DFA60.3030106@swiftspirit.co.za>
Date: Sat, 22 Mar 2014 23:02:24 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Send/Receive howto and script for others to use (was Re: Is anyone
 using btrfs send/receive)
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20140107104951.GL10936@merlins.org> <20140107105329.GE15634@carfax.org.uk> <20140108080206.GV10936@merlins.org> <20140321172904.GE28005@merlins.org> <532DE805.7040407@swiftspirit.co.za> <20140322200057.GJ28005@merlins.org>
In-Reply-To: <20140322200057.GJ28005@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/22 10:00 PM, Marc MERLIN wrote:
> On Sat, Mar 22, 2014 at 09:44:05PM +0200, Brendan Hide wrote:
>> Hi, Marc
>>
>> Feel free to use ideas from my own script. Some aspects in my script are
>> more mature and others are frankly pathetic. ;)
>>
>> There are also quite a lot of TODOs throughout my script that aren't
>> likely to get the urgent attention they deserve. It has been slowly
>> evolving over the last two weeks.
>>
>> http://swiftspirit.co.za/scripts/btrfs-snd-rcv-backup
> I figured I likely wasn't the only one working on a script like this :)
>
>  From a quick read, it looks even more complex than mine :) but
Well ... I did say some things are pathetic my side. ;) I also use a 
template (its about 3 years old now) when I make a new script, hence the 
options such as being able to ignore the mutex checks and also having a 
random delay at start. These obviously add some unnecessary complexity.
> - it doesn't do ssh to a destination for a remote backup
There should be a TODO for this on my side. Presently in testing I'm 
only using it for device-local backup to a separate disk and not to a 
"proper" remote backup.
> - it doesn't seem to keep a list of configurable snapshots not necessary for
> send/restore but useful for getting historical data
I'm not sure what this is useful for. :-/ If related, I plan on creating 
a separate script to move snapshots around into _var_daily_$date, 
_var_weekly_$date, etc.
> - it doesn't seem to use a symlink to keep track of the last complete
> snapshot on the source and destination, and does more work to compensate
> when recovering from an incomplete backup/restore.
Yes, a symlink would make this smoother.
> - it doesn't create writeable snapshots on the destination in case you want
> to use the copy as a live filesystem
One of the issues with doing writeable snapshots by default is that the 
backup is (ever so slightly) less safe from "fat-finger syndrome". If I 
want a writeable snapshot, I'll make it from the read-only snapshot, 
thereby reducing the chances of accidentally "tainting" or deleting data 
in the backup. I actually *did* accidentally delete my entire filesystem 
(hence the paranoid umounts). But, of course, my script *first* created 
read-only snapshots from which recovery took only a few minutes. ;)
> Things I noticed:
> - I don't use ionice, maybe I should. Did you find that it actually made a
> difference with send/receive?
This is just a habit I've developed over time in all my scripts. I 
figure that if I'm using the machine at the time and the snapshot has a 
large churn, I'd prefer the ionice. That said, the main test system is a 
desktop which is likely to have much less churn than a server. In the 
last two weeks the longest daily incremental backup took about 5 minutes 
to complete, while it typically takes about 30 seconds only.
> - Your comments say shlock isn't safe and that's documented. I don't see
> that in the man page
> http://manpages.ubuntu.com/manpages/trusty/man1/shlock.1.html
That man page looks newer than the one I last looked at - specifically 
the part saying "improved by Berend Reitsma to solve a race condition." 
The previous documentation on shlock indicated it was safe for hourly 
crons - but not in the case where a cron might be executed twice 
simultaneously. Shlock was recommended by a colleague until I realised 
this potential issue, thus my template doesn't use it. I should update 
the comment with some updated information.

My only two worries then would be a) if it is outdated on other distros 
and b) that it appears that it is not installed by default. On my Arch 
desktop it seems to be available with "inn"[1] (Usenet server and 
related software) and nowhere else. It seems the same on Ubuntu (Google 
pointed me to inn2-dev). Do you have INN installed? If not, where did 
you get shlock from?
> I'd love to have details on this if I shouldn't be using it
> - Is set -o noclobber; echo $$ > $lockfile really atomic and safer than
> shlock? If so, great, although I would then wonder why shlock even exists :)
The part that brings about an atomic lock is "noclobber", which sets it 
so that we are not allowed to "clobber"/"overwrite" an existing file. 
Thus, if the file exists, the command fails. If it successfully creates 
the new file, the command returns true.

I'd consider changing this mostly for the fact that depending on INN is 
a very big dependency. There are other options as well, though I don't 
think they're as portable as noclobber.
>
> Thanks,
> Marc

Thanks for your input. It has already given me some direction. :)

[1] https://www.archlinux.org/packages/community/x86_64/inn/files/

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

