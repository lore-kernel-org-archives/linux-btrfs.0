From: Josef Bacik <josef@redhat.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 07 Oct 2011 10:48:08 -0400
Message-ID: <4E8F1128.4000508@redhat.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk> <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com> <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com> <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com> <20111007025050.GA4767@shiny.Netlink.Wireless> <CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/07/2011 09:40 AM, Jeff Putney wrote:
>> For fsck, even the stuff I have here does have a way to go before it is
>> at the level of an e2fsck or xfs_repair.  But I do want to make sure
>> that I'm surprised by any bugs before I send it out, and that's just not
>> the case today.  The release has been delayed because I've alternated
>> between a few different ways of repairing, and because I got distracted
>> by some important features in the kernel.
> 
> I think there is a major difference between touching up a few bugs
> before you release the code, and experimenting with a bunch of
> different ways of repairing before you release the code.  I know I for
> one would get as much value out of reading the code for the strategies
> you abandoned as I would get from reading the final code, but I don't
> know if having those branches in the main repo would have any value
> for the project as a whole.
> 
> As the current solution goes, I'd just like to see a stake in the
> ground for some sort of process to move away from the one man army
> approach, should distractions etc continue.  Given the latest 2 week
> estimate, something along the lines of, in 4 or 6 weeks, if it still
> isn't 'ready', code will start to be released.
> 
> 
>> That's how software goes sometimes, and I'll take the criticism because
>> it hasn't gone as well as it should have.  But, I can't stress enough how
>> much I appreciate everyone's contributions and interest in btrfs.
>>
>> -chris
> 
> I'm only criticizing the decision to not release the source, in
> particular given the delays.  We all have our priorities and
> distractions, and s**t happens.  (Part of why I'd argue against the
> flying solo strategy.)  But, I really do appreciate all the stuff
> you've built, which is part of why I am so keen on reading it. :-) .
> 

The problem is people won't just read it, they will use it.  I wrote a
basic repair tool for a user in Fedora who seemed to have a very
specific kind of corruption, and earlier this week almost a month after
my initial repair tool I had to write another tool to go in and just
pull all his data off his disk because a bug in my repair tool made his
fs _WORSE_, to the point I'm not sure I can fix it.  Fsck has the
potential to make any users problems worse, and given the increasing
number of people putting production systems on btrfs with no backups the
idea of releasing a unpolished and not fully tested fsck into the world
is terrifying, and would likely cause long term "I heard that file
system's fsck tool eats babies" sort of reputation.

Release early and release often is nice for web browsers and desktop
environments, it's not so nice with things that could result in data
loss, especially when our user base is growing in leaps and bounds and
aren't necessarily informed enough on the dangers of using an file
system that's still under heavy development.  Thanks,

Josef
