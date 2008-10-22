From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 13:36:15 +0200
Message-ID: <20081022133615.68b66b0e.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<87vdvmdu36.fsf@basil.nowhere.org>
	<20081021162249.30a25bcb.skraw@ithnet.com>
	<48FDF67C.6080205@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FDF67C.6080205@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2008 11:34:20 -0400
jim owens <jowens@hp.com> wrote:

> Hearing what user's think they want is always good, but...
> 
> Stephan von Krawczynski wrote:
> > 
> > thanks for your feedback. Understand "minimum requirement" as "minimum
> > requirement to drop the current installation and migrate the data to a
> > new fs platform".
> 
> I would sure like to know what existing platform and filesystem
> you have that you think has all 10 of your features.

Obviously none, else I would not speak up and try to find one. :-)

> > [...]
> > 1) parallel mounts
> 
> What I see from that explanation is you have a "system design" idea
> using parallel machines to fix problems you have had in the past.
> To implement your design, you need a filesystem to fit it.

Well, I can't hardly deny that. Lets just name the (simple) problem, different
names for the very same thing: uptime, availability, redundancy

>  I think
> it is better to just design a filesystem without the problems and
> configure the hardware to handle the necessary load.

Ok, now you see me astonished. You really think that there is one piece of
software around that is "without problems" ?
My idea of the world is really very different from that:
The world is far from perfect. That is why I try to deploy solutions that have
redundancy for all kinds of problems I can think of and hopefully for a few
that I haven't thought of.
 
> > 2) mounting must not delay the system startup significantly
> > 3) errors in parts of the fs are no reason for a fs to go offline as a whole
> > 4) power loss at any time must not corrupt the fs
> > 5) fsck on a mounted fs, interactively, not part of the mount (all fsck
> > features)
> 
> I think all of these are part of the "reliability" goal for btrfs
> and when you say "fsck" it is probably misleading if I understand
> your real requirement to be the same as my customers:
> 
>    - *NO* fsck
>    - filesystem design "prevents problems we have had before"
>    - filesystem autodetects, isolates, and (possibly) repairs errors
>    - online "scan, check, repair filesystem" tool initiated by admin
>    - Reliability so high that they never run that check-and-fix tool

That is _wrong_ (to a certain extent). You _want to run_ diagnostic tools to
make sure that there is no problem. And you don't want some software (not even
HAL) to repair errors without prior admin knowledge/permission.
 
> Note that I personally have never seen a first release meet
> the "no problems, no need to fix" criteria that would obviate
> any need for a check/fix tool.

That really does not depend on the release number of _your_ special software.
Your software always depends on other components (hw or sw) that (can) have
bugs and weird behaviour. And this is the fact: no perfect world, so don't
count on your or others' perfectness. If you do you will fail.
 
> jim

-- 
Regards,
Stephan

