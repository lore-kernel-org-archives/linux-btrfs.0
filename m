Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57197 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934556AbcATSV5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 13:21:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLxOC-0006WV-8r
	for linux-btrfs@vger.kernel.org; Wed, 20 Jan 2016 19:21:52 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 19:21:52 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 19:21:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Date: Wed, 20 Jan 2016 18:21:39 +0000 (UTC)
Message-ID: <pan$d1dea$2c1e6be0$a862d54$c7232097@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
	<569C41B1.1090206@cn.fujitsu.com>
	<pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
	<569C58FB.70407@cn.fujitsu.com>
	<pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net> <569CDF0D.9030609@gmail.com>
	<pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
	<569E2A44.3040109@gmail.com> <loom.20160120T161107-907@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Al posted on Wed, 20 Jan 2016 15:12:09 +0000 as excerpted:

> Sometimes it's the odd OT posts that are the most interesting!

Now you got me going philosophical.  =:^)  The following may be 
interesting, but it's only on topic in a rather "meta" sense.  Many will 
wish to skip.

That's actually what has kept me "addicted" to newsgroups and mailing 
lists (which I do via gmane.org's list2news service as newsgroups) over 
the decades.  Just when a topic is getting boring and you're thinking 
about unsubscribing, along comes something entirely OT and unpredictable 
that's really helpful in some other area, either right now, or to be 
tucked away for later, either for myself or to pass on to someone else 
who it can help in some list/news discussion.

Plus, this being a kernel and filesystem related list, the depth of 
technical knowledge available here is simply amazing.

Nearly two decades ago now, I had an experience every technically 
inclined geek needs to have at some point, as it would solve a lot of 
problems.  To that point, I had often been among the most technically 
knowledgeable in many of my online discussions, even tho on the MSIE 
groups especially, some of them were responsible for an impressive number 
of boxes.  Then I ended up on a DSL ISP called Speakeasy, which at the 
time was pretty small, but growing, having originated out of a Seattle 
tea and coffee house (!!) of the same name.  A few years later it had 
gone to **** and I switched, but for a few years, it had some /really/ 
knowledgeable Unix/Linux/BSD folks, including one with direct commit 
access to one of the BSDs.  They were an /immense/ help when I was 
switching to Linux, but there's a rather different point here.

Like I said, until that point I was used to being one of the higher 
technically literate folks around, to the point even people in charge of 
fleets of thousands of (MS-based) computers were taking my advice on the 
then new IE4 and 5, MS Active Desktop, W98, etc.  But on that ISP, I very 
quickly learned how little I actually knew, becoming technically speaking 
the newbie.  For the first time in my life I couldn't simply make 
statements about how I thought the technology at hand worked and have 
people take them as truth because it was enough out of their realm they 
had no way to question it.  I was challenged on my statements, and had to 
back down a couple times before I very quickly learned to qualify things 
I wasn't sure of, as on that ISP's newsgroup, the tables really were 
turned and I was the technical know-nothing, at least compared to the 
knowledge and experience of these guys.

That's an incredibly valuable life lesson and experience to learn/have.  
Since then, as I've watched the various larger than life technical 
personalities and seen the various arguments, too many of which end up 
with someone with incredible technical skills leaving, I think back, and 
wish they could have had a similar experience somewhat earlier.  I'm 
absolutely sure if they had, that we'd not have the acrimonious forks, 
etc, that so often happen in the FLOSS world, the problem being that like 
me back then, so many technical leaders are simply used to being able to 
make technical statements unquestioned, and simply don't have the skills 
to deal with people at the same level actually being able to question 
them and their statements at their own level or above, because other than 
these rare cases which all too often end up going nuclear, there's simply 
no one at their level, /able/ to question them and to hold them to proper 
accountability.  Were they to have had at some earlier point an 
experience like I had at Speakeasy to (nicely but firmly) put them in 
their place as I was put in mine...  Of course, the Asperger Syndrome the 
highly technically inclined often have, to one degree or another, doesn't 
help...

Anyway, on this list I'm in very much the same position, dealing with 
people significantly above my own level, an otherwise somewhat rare 
experience in my life, almost non-existent "in real life", still rare, 
but much less so, online.  But I learned from that earlier experience, 
which is why you'll so often see "not a dev only a user and list regular" 
disclaimers on my posts, as well as many /many/ more "AFAIK", "I 
believe", "based on what I've seen on-list", "if a dev says different, 
listen to them, not me", etc.

And actually, learning to add those qualifiers has saved my *** a few 
times in other contexts, both online and off, as well, allowing me a 
graceful out when otherwise I'd have been forced to either defend a wrong 
position I backed myself into, or take a humiliating defeat.  Just one 
little AFAIK or "I believe" makes it /so/ much easier to back down, if it 
comes to that.  =:^)

Meanwhile, as here I /am/ among those well above my own level, I'm not 
afraid to ask the opportunistic question when I don't know, either, as 
this subthread demonstrates.

So let the development... and learning, continue! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

