From: jim owens <jowens@hp.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 11:34:20 -0400
Message-ID: <48FDF67C.6080205@hp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	<87vdvmdu36.fsf@basil.nowhere.org> <20081021162249.30a25bcb.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021162249.30a25bcb.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hearing what user's think they want is always good, but...

Stephan von Krawczynski wrote:
> 
> thanks for your feedback. Understand "minimum requirement" as "minimum
> requirement to drop the current installation and migrate the data to a
> new fs platform".

I would sure like to know what existing platform and filesystem
you have that you think has all 10 of your features.

> Of course you are right, dealing with multiple/parallel mounts can be quite a
> nasty job if the fs was not originally planned with this feature in mind.
> On the other hand I cannot really imagine how to deal with TBs of data in the
> future without such a feature.
> If you look at the big picture the things I mentioned allow you to have
> redundant front-ends for the fileservice doing the same or completely
> different applications. You can use one mount (host) for tape backup purposes
> only without heavy loss in standard file service. You can even mount for
> filesystem check purposes, a box that does nothing else but check the
> structure and keep you informed what is really going on with your data - and
> your data is still in production in the meantime.
> Whatever happens you have a real chance of keeping your file service up, even
> if parts of your fs go nuts because some underlying hd got partially damaged.
> Keeping it up and running is the most important part, performance is only
> second on the list.
> If you take a close look there are not really 10 different items on my list,
> depending on the level of abstraction you prefer, nevertheless:
> 
> 1) parallel mounts

What I see from that explanation is you have a "system design" idea
using parallel machines to fix problems you have had in the past.
To implement your design, you need a filesystem to fit it.  I think
it is better to just design a filesystem without the problems and
configure the hardware to handle the necessary load.

> 2) mounting must not delay the system startup significantly
> 3) errors in parts of the fs are no reason for a fs to go offline as a whole
> 4) power loss at any time must not corrupt the fs
> 5) fsck on a mounted fs, interactively, not part of the mount (all fsck
> features)

I think all of these are part of the "reliability" goal for btrfs
and when you say "fsck" it is probably misleading if I understand
your real requirement to be the same as my customers:

   - *NO* fsck
   - filesystem design "prevents problems we have had before"
   - filesystem autodetects, isolates, and (possibly) repairs errors
   - online "scan, check, repair filesystem" tool initiated by admin
   - Reliability so high that they never run that check-and-fix tool

Note that I personally have never seen a first release meet
the "no problems, no need to fix" criteria that would obviate
any need for a check/fix tool.

jim
