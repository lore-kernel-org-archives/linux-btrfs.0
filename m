Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:46960 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbdLSU2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 15:28:54 -0500
Date: Tue, 19 Dec 2017 21:28:52 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: George Mitchell <george@chinilu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171219202852.GA14726@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <f6785d3b-89fc-fd3b-38fe-815613b335fb@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <f6785d3b-89fc-fd3b-38fe-815613b335fb@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 10:31:40 -0800, George Mitchell wrote:

> I have significant experience as a user of raid1. I spent years using 
> software raid1 and then more years using hardware (3ware) raid1 and now 
> around 3 years using btrfs raid1. I have not found btrfs raid1 to be 
> less reliable than any of the previous implementations of raid.  I have 

You are aware that in order to proof something one needs only one
example? Degraded r/o is such, QED.
Doesn't matter how long did you ride on top of any RAID implementation,
unless you got them in action, i.e. had actual drive malfunction. Did you
have broken drive under btrfs raid?

> a failure, you don't just plug things back in and expect it to be fixed 
> without seriously investigating what has gone wrong and potential 
> unexpected consequences.  I have found that even with hardware raid you 
> can find ways to screw things up to the point that you lose your data.  

Everything could be screwed beyond comprehension, but we're talking
about PRIMARY objectives. In case of RAID1+ it seems to be obvious:

https://en.oxforddictionaries.com/definition/redundancy

- unplugging ANY SINGLE drive MUST NOT render system unusable.
This is really as simple as that.

> I have had situations where I reconnected a drive on hardware raid1 only 
> to find that the array would not sync and from there on I ended up 
> having to directly attach one of the drives and recover the partition 

I had a situation when replugging a drive started a sync of older data
over the newer. So what? This doesn't change a thing - the drive
reappearance or resync is RECOVERY part. RECOVERY scenarios are entirely
different thing than REDUNDANCY itself. RECOVERY phase in some
implementation could be entirely off-line process and it still would be
RAID. Remove REDUNDANCY part and it's not RAID anymore.

If one is naming thing an apple, shouldn't be surprised if others
compare it to apples, not oranges.

> table with test disk in order to regain access to my data.  So NO FORM 
> of raid is a replacement for backups and NO FORM of raid is a 
> replacement for due diligence in recovery from failure mode.  Raid gives 

And who said it is?

> you a second chance when things go wrong, it does not make failures 
> transparent which is seemingly what we sometimes expect from raid.  And 

Wouldn't want to worry you, but properly managed RAIDs make I/J-of-K
trivial-failures transparent. Just like ECC protects N/M bits transparently.

Investigating the reasons is sysadmin's job, just like other
maintenance, including restoring protection level.

-- 
Tomasz Pala <gotar@pld-linux.org>
