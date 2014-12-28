Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39213 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaL1MDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 07:03:54 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Robert White <rwhite@pobox.com>
Cc: Bardur Arantsson <spam@scientician.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sun, 28 Dec 2014 13:03:48 +0100
Message-ID: <2319142.UG75f3UqXt@merkaba>
In-Reply-To: <549F80FD.4050804@pobox.com>
References: <3738341.y7uRQFcLJH@merkaba> <m7nkoo$15b$1@ger.gmane.org> <549F80FD.4050804@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 27. Dezember 2014, 20:03:09 schrieb Robert White:
> On 12/27/2014 05:01 PM, Bardur Arantsson wrote:
> > On 2014-12-28 01:25, Robert White wrote:
> >> On 12/27/2014 08:01 AM, Martin Steigerwald wrote:
> >>>>  From how you write I get the impression that you think everyone else
> >>> beside you is just silly and dumb. Please stop this assumption. I may not
> >>> always get terms right, and I may make a mistake as with the wrong df
> >>> figure. But I also highly dislike to feel treated like someone who
> >>> doesn´t
> >>> know a thing.
> >>
> >> Nope. I'm a systems theorist and I demand/require variable isolation.
> >>
> >> Not a question of "silly" or "dumb" but a question of "speaking with
> >> sufficient precision and clarity".
> >>
> >> For instance you speak of "having an impression" and then decide I've
> >> made an assumption.
> >>
> >> I define my position. Explain my terms. Give my examples.
> >>
> >> I also risk being utterly wrong because sometimes being completely wrong
> >> gets others to cut away misconceptions and assumptions.
> >>
> >> It annoys some people, but it gets results.
> >
> > Can you please stop this bullshit posturing nonsense? It accomlishes
> > nothing -- if you're right your other posts will stand for themselves
> > and show that you are indeed "the shit" when it comes to these matters,
> > but this post (so far, didn't read further) accomplishes nothing other
> > than (possibly) convincing everyone that you're a pompous/self-important
> > ass.
> 
> Really? "accomplishes nothing"?
> 
> 24 hours ago:
> 
> the complaining party was talking about
> 
> - Windows XP
> - Tax software
> - Virtual box
> - vdi files
> - defragging
> - balancing
> - "data trees"
> - system hanging
> 
> And the responding party was saying
> 
> "you are the only person reporting this as a regular occurrence" with 
> the implication that the report was a duplicate or at least might not 
> get much immediate attention.
> 
> Now:
> 
> The complaining party has verified the minimum, repeatable case of 
> simple file allocation on a very fragmented system and the responding 
> party and several others have understood and supported the bug.

It was repeatable before. That I go from application case to simulate a
workload case is only natural. Or do you run fio or other load testing apps
as a part of your daily work on your computer (unless you are actually
diagnosing performance issues). I still *use* the computer with
applications. And if thats where I see the performance issue, I report as
such. Then I think about the kind of workload it creates and go from there
to simplicy it to a reproducable case.

At least I read mails, browse the web, run a VM, and so such kinds of
things as daily computer usage. And thus its likely that performance issues
show like this. Heck even my server does mail and Owncloud and things.

I only use workload generation tools during my teachings or when analysing
things, not as part of my daily computer usage.

And that doesn´t make using a VM any less valid. And if it basically crawls
BTRFS to an halt, I report this. Its actually that easy.

> That's not "accomplishing nothing", thats called engaging in diagnostics 
> instead of dismissing a complaint, and sticking out the diagnostic 
> process until everyone is on the same page.
> 
> I never dismissed Martin. I never disbelieved him. I went through his 
> elements one at a time with examples of what I was taking away from him 
> and why they didn't match expectations and experimental evidence. We 
> adjusted our positions and communications.

Robert, I received this differently. I received your input partly as wronging
me. Granted that motivated me even more to prove things. But I highly
dislike this kind of motivation. As I think I am motivated myself. I like
finding causes of performance bottle necks. And I prefer positive motivation
instead of negative one.

> So you can call it "bullshit posturing nonsense" but I see "taking less 
> than a day to get to the bottom of a bug report that might not have 
> gotten significant attention."

And you attribute all of this to your argumentation?

Thats bold.

See, Robert, your arguments helped with clearing my understanding in some
parts. Especially on the terms I have not been very familiar.

I am grateful for that.

It even helped motivate me to do the further tests, as I got the
impression that you have just been discussing that what I am seeing is
just the way BTRFS necesessarily is *algorithmically* and I was just using
it wrongly. But that said: I have an interest myself in resolving this.
I was prepared for giving additional input at a given time. But right on
this day I was just fed up with things.

It motivated to prove the abysmal performance behaviour in a certain
workload.

Robert, your arguments contributed, thats true. But still I did the work of
the actual measurements. I spent the hours on doing the measurements,
with a slight risk of having to restore from backup, incase BTRFS would
mess up things. I was the one bringing BTRFS to the limits where it
actually shows an issue, instead of theoreticing about the limit as being
an algorithmic issue or wrong usage.

I expect the process to be iterative. At first I see something, get an
impression and probably a gut feeling. And then I move on from that.

Maybe you are the superguru who has the complete picture at the time
you see an issue. But I see things and then try to make sense of them,
actively allowing for feedback on the way. I start research then. And this
research is iterative. And yet, I am so bold, to post things on this mailing
list even if they are not yet a fully fledged out scientific document. Even
if I didn´t get all BTRFS specific terms right – but still had about quite an
accurate understanding on what I was seeing. In order for others to chime
in and give ideas.

At first I partially ranted. Yes, I even said so. Cause I am human. Thats
it. I wanted to progress on my tax return and BTRFS messed up. And I
spent literally hours on fixing things then, even copying back the VDI file
from backup as Windows did come chkdsk on it and I wasn´t so sure anymore
about its consistency. Heck I even succeeded at it. By even doing something
that is *not* recommended, but *still* works: The balance. I have been – I´d
say rightfully so – angry at that. If confronted with theory and with real
world perception, I always take what I perceive first. If theory says a
balance is not supposed to help, I´d still balance if I see that it does. Its
that simple, cause I found it quite fruitless to argue with the world. If
it rains while it shouldn´t I still prepare myself for the rain when going
out.

And heck, my initial impression still stands, Robert. I have shown a case
where BTRFS becomes CPU bound and basically crawls to a halt and I
still think this is a (performance) bug. We will see, whether it is. And no,
it wasn´t the dirty background ratio or the SSDs being to fast for the CPU
as you tried to guess (even due I am using 3.18 with that multiqueue block
I/O handling enabled, at least I think it is enabled). (I am aware of all of
this and I am aware of the work in the Linux kernel to support a million
of IOPS or more or that certain PCIe flash drivers at least at some tme
circumvented parts of block I/O layer. But I also know I just have some
SATA SSDs, connected via SATA-300 and thats a difference in the amount
of IOPS they can actually produce)

And also given the history, what I reported is *new*. I saw this for the first
time like this. It doesn´t have a fruitless history of not going to the root
cause. The last thing others and I reported is fixed already. The hangs in
3.15 and 3.16. I provided information on these as well, if you care to
lookup in the mailing list archives. I tested patches to solve them. Just
check the mailing list archives for this. Its not even the first BTRFS issue
I helped diagnosing.

I simply wasn´t aware that this isn´t a permanent lock, as I gave up waiting
for the desktop to return after some minutes, cause I simply wanted to get
my work done. At some certain time I may not be willing to spend hours to
find the root cause of a problem, but will just workaround it.

So I just wrote that I saw these kworker process spinning on 100% CPU
and my desktop has locked. I didn´t include the information on the process
state of the desktop processes, but it was basically the dialog on IRC I
had with Hugo which cleared that out. As far as I am aware none of your
argumentation contributed to that. For me it was a hang, cause things
hanged. Whether permanent or not? How long do you wait to determine that?


I close with how I like this process to work:

I perceive something, I may have an idea about it, but then I proceed
from there without anysuming anyone is "right" or "wrong" about something.

And it is this "wronging" of others that I perceived here, that I think
received from you as a message, at least thats how I received some of what
you wrote, what I want to stop right now. If you didn´t send it, we
misunderstood. But thats how I received some of your arguments. As
dismissive of my +10 years of Linux experiences and +6-7 years of
actually *teaching* performance analysis & tuning.

Still I find myself knowing nothing at times. And thats good. Cause that
is how I learn. How even did I see values that just didn´t make any sense.
In the beginning. In the end the did.

So I am learning. You are learning. Everybody is learning.

At first I see something and describe it as it is… I used unclear terms on it
and it helped to clarify this. And then I try to understand whats happening.

That is how it works for me.

I very much like to proceed on this with that kind of attitude. And in that
sense I look forward to your valuable input on this as it progresses to
an conclusion.

So can we just assume that we are all experts and beginners at the same
time and capable and helpful and willing to learn and go along like this?

That´s what I call productive.


Okay, that was lengthy, and I have a part in this. Actually I felt offended.
Maybe by misunderstanding you. But thats how I received some of your
statements.



BTW, I found that the Oracle blog didn´t work at all for me. I completed
a cycle of defrag, sdelete -c and VBoxManage compact, not due to being
much interested in it at all, but also as part of my BTRFS testing, and it
apparently did *nothing* to reduce the size of the file. That was my initial
motivation with that: To reduce the size of the file to make more free space
for BTRFS. And I was using at whats recommended by company whose
developers develop Virtualbox. Disliking the defragment step from the
beginning (as useless on SSD). But I thought, heck if it gives me a smaller
file, all good.

Next time I just give it 10 GiB instead of 20 GiB from the beginning. Or
at some time I find a Linux based task returns software. I wonder what
the authorities would say when I say I can´t complete my tax returns as
my operating system is not supported by the software necessary for it.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
