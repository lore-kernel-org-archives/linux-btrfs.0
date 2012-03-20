From: Skylar Burtenshaw <daninfuchs@gmail.com>
Subject: Re: Can't mount, power failure - recoverable?
Date: Tue, 20 Mar 2012 03:06:42 +0000 (UTC)
Message-ID: <loom.20120320T035257-31@post.gmane.org>
References: <loom.20120317T051243-551@post.gmane.org> <CAE5mzvi8oX4B+yriTRnj_g+_a3=BoC-o1BSRs4PpJsAMBOP5xw@mail.gmail.com> <loom.20120317T192345-893@post.gmane.org> <20120318151615.GE3976@shiny> <loom.20120318T193113-459@post.gmane.org> <20120319180235.GH3976@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> ;) 
I like you. Hehe.. ;)


> Ok, so the good news is that you're crashing when you try to write to
> the FS.

Well, I'll go ahead and assume you're right (you know, since it's your baby and
all, and you know what you're talking about better than anyone I can think of)
but the problem here is that I'm not getting past "mount". "mount /dev/sda3
/mnt/tmp" ....churn churn churn, about a minute or two later, bam, kernel stack
trace. If it's crashing because it's being written to, it's not because I'm
asking it to write. Though on that note, I tried 'mount -o ro,recovery' and got
"mount: Stale NTFS handle" which..made me lol. Same with just '-o ro'. '-o
recovery' procudes a stack trace. And, just for the heck of it (because I have
too much time on my hands) I tried chmod'ing -r to all of the dev nodes of the
drives in the array - surprise surprise, same stack trace.


> Starting with 3.2, these are fixed.

This makes me happy, because I feel that I can now trust it more. Especially
since I kicked out the $200 for batteries for that damn UPS.. Rack systems are
expensive.


> The safest way forward from here is to just copy your data off and run a
> newer kernel.

One step ahead of you there, thankfully.


>  Do you have the spare capacity for this?

I'm not sure how cursing is looked upon on this group, so I'll simply say "no"
and let your imagination fill in the blanks..hah. I could probably limp it, if I
was able to transfer approx. 1tb then remove a drive from the filesystem and add
it to my backup system, but that'd get hairy fast. Especially since the FS is
'damaged' and likely would not survive removal. If you say the only way is to
copy data off, I'll find a way - be it credit or borrowing drives - since I know
that's likely what it'll come to...but that's last resort, for me. At this
point, I almost want to hear "you're screwed" just so I can be done with it, but
it would not make me happy. Thanks so much for your support.

