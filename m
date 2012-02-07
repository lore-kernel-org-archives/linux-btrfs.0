From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Tue, 7 Feb 2012 08:36:15 -0600
Message-ID: <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
References: <20120205184128.GC18806@localhost.localdomain>
	<20120207033945.GA5639@localhost.localdomain>
	<pan.2012.02.07.09.53.58@cox.net>
	<20120207140431.GB5639@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
To: nemesis@icequake.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120207140431.GB5639@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 7, 2012 at 8:04 AM, Ryan C. Underwood
<nemesis-lists@icequake.net> wrote:
>
>> > Unfortunately, I am going to have to give up on btrfs if it
>> > is really so fragile.
>>
>> However, complaining about the fragility of a still in development
>> and
>> marked experimental filesystem would seem disingenuous at best.
> [snip paragraphs of tut-tutting]
>> IOW, yes, btrfs is to be considered fragile at this point.
>
> So you re-stated my position. =A0I gave btrfs a chance but it is stil=
l
> apparently far more fragile than ext4 when corruption is introduced -=
-
> although btrfs is the filesystem of the two which is specifically
> designed to provide internal fault tolerance and resilience. =A0Is th=
ere
> a fine line between "user feedback" and "disingenuous complaining"
> that I am not aware of?
>
> The data in question is not that important, though I would like to
> have it back considering it should mostly still be there as on the
> ext4 volumes. =A040MB of bad sectors on one 2TB disk in a 6TB volume
> does not seem like a lot. =A0Even if the whole beginning of the volum=
e
> was wiped out surely there is the equivalent of backup superblocks? =A0=
I
> can hack if I could just get a clue where to start.
>

Since you're getting "failed to read /dev/sr0" messages, that might be
an indication there are some newer btrfs-progs tools available.

You might want to try the building btrfs-progs from the git repository:
http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-progs.git;a=3Ds=
ummary

There are some recovery tools there that may extract your data (look
at the "recover" program).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
