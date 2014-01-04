Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49114 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaADGKn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 01:10:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzKRU-0002iq-Vy
	for linux-btrfs@vger.kernel.org; Sat, 04 Jan 2014 07:10:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 07:10:40 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 07:10:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sat, 4 Jan 2014 06:10:14 +0000 (UTC)
Message-ID: <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com>
	<52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>
	<52C74415.3020407@jrs-s.net>
	<7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 03 Jan 2014 16:22:44 -0700 as excerpted:

> I would not make this option persistent by putting it permanently in the
> grub.cfg; although I don't know the consequence of always mounting with
> degraded even if not necessary it could have some negative effects (?)

Degraded only actually does anything if it's actually needed.  On a 
normal array it'll be a NOOP, so should be entirely safe for /normal/ 
operation, but that doesn't mean I'd /recommend/ it for normal operation, 
since it bypasses checks that are there for a reason, thus silently 
bypassing information that an admin needs to know before he boots it 
anyway, in ordered to recover.

However, I've some other comments to add:

1) As you I'm uncomfortable with the whole idea of adding degraded 
permanently at this point.

Mention was made of having to drive down to the data center and actually 
stand in front of the box if something goes wrong, otherwise.  At the 
moment, for btrfs' development state at this point, fine.  Btrfs remains 
under development and there are clear warnings about using it without 
backups one hasn't tested recovery from or are not otherwise prepared to 
actually use.  It's stated in multiple locations on the wiki; it's stated 
on the kernel btrfs config option, and it's stated in mkfs.btrfs output 
when you create the filesystem.  If after all that people are using it in 
a remote situation where they're not prepared to drive down to the data 
center and stab at the keys if they have to, they're using possibly the 
right filesystem, but at the wrong too early point in its development, 
for their needs at this moment.


2) As the wiki explains, certain configurations require at least a 
minimum number of devices in ordered to work "undegraded".  The example 
given in the OP was of a 4-device raid10, already the minimum number to 
work undegraded, with one device dropped out, to below the minimum 
required number to mount undegraded, so of /course/ it wouldn't mount 
without that option.

If five or six devices would have been used, a device could have been 
dropped and the remaining number of devices would still be greater than 
or equal to the minimum number of devices to run an undegraded raid10, 
and the result would likely have been different, since there's still 
enough devices to mount writable with proper redundancy, even if existing 
information doesn't have that redundancy until a rebalance is done to 
take care of the missing device.

Similarly with a raid1 and its minimum two devices.  Configure with 
three, then drop one, and it should still work as it's above the two 
minimum for raid1 configuration.  Configure with two and drop one, and 
you'll have to mount degraded (and it'll drop to read-only if it happens 
in operation) since there's no second device to write the second copy to, 
as required by raid1.

3) Frankly, this whole thread smells of going off half cocked, posting 
before doing the proper research.  I know when I took a look at btrfs 
here, I read up on the wiki, reading the multiple devices stuff, the faq, 
the problem faq, the gotchas, the use cases, the sysadmin guide, the 
getting started and mount options... loading the pages multiple times as 
I followed links back and forth between them.

Because I care about my data and want to understand what I'm doing with 
it before I do it!

And even now I often reread specific parts as I'm trying to help others 
with questions on this list....

Then I still had some questions about how it worked that I couldn't find 
answers for on the wiki, and as traditional with mailing lists and 
newsgroups before them, I read several weeks worth of posts (on an 
archive for lists) before actually posting my questions, to see if they 
were FAQs already answered on the list.

Then and only then did I post the questions to the list, and when I did, 
it was, "Questions I haven't found answers for on the wiki or list", not 
"THE WORLD IS GOING TO END, OH NOS!!111!!111111!!!!!111!!!"

Now later on I did post some behavior that had me rather upset, but that 
was AFTER I had already engaged the list in general, and was pretty sure 
by that point that what I was seeing was NOT covered on the wiki, and was 
reasonably new information for at least SOME list users.

4) As a matter of fact, AFAIK that behavior remains relevant today, and 
may well be of interest to the OP.

FWIW my background was Linux kernel md/raid, so I approached the btrfs 
raid expecting similar behavior.  What I found in my testing (and NOT 
covered on the WIKI or in the various documentation other than in a few 
threads on list to this day, AFAIK) , however...

Test:  

a) Create a two device btrfs raid1.

b) Mount it and write some data to it.

c) Unmount it, unplug one device, mount degraded the remaining device.

d) Write some data to a test file on it, noting the path/filename and 
data.

e) Unmount again, switch plugged devices so the formerly unplugged one is 
now the plugged one, and again mount degraded.

f) Write some DIFFERENT data to the SAME path/file as in (d), so the two 
versions each on its own device have now incompatibly forked.

g) Unmount, plug both devices in and mount, now undegraded.

What I discovered back then, and to my knowledge the same behavior exists 
today, is that entirely unexpectedly from and in contrast to my mdraid 
experience, THE FILESYSTEM MOUNTED WITHOUT PROTEST!!

h) I checked the file and one variant as written was returned.  STILL NO 
WARNING!  While I didn't test it, I'm assuming based on the PID-based 
round-robin read-assignment that I now know btrfs uses, that which copy I 
got would depend on whether the PID of the reading thread was even or 
odd, as that's what determines what device of the pair is read.  (There 
has actually been some discussion of that as it's not a particularly 
intelligent balancing scheme and it's on the list to change, but the 
current even/odd works well enough for an initial implementation while 
the filesystem remains under development.)

i) Were I rerunning the test today, I'd try a scrub and see what it did 
with the difference.  But I was early enough in my btrfs learning that I 
didn't know to run it at that point, so didn't do so.  I'd still be 
interested in how it handled that, tho based on what I know of btrfs 
behavior in general, I can /predict/ that which copy it'd scrub out and 
which it would keep, would again depend on the PID of the scrub thread, 
since both copies would appear valid (would verify against their checksum 
on the same device) when read, and it's only when matched against the 
other that a problem, presumably with the other copy, would be detected.

My conclusions were two:  

x) Make *VERY* sure I don't actually do that in practice!  If for some 
reason I mount degraded, make sure I consistently use the same device, so 
I don't get incompatible divergence.

y) If which version of the data you keep really matters, in the event of 
a device dropout and would-be re-add, it may be worthwhile to discard/
trim/wipe the entire to-be-re-added device and btrfs device add it, then 
balance, as if it were an entirely new device addition, since that's the 
only way I know of to be sure that the wrong copy isn't picked.

This is VERY VERY different behavior than mdraid would exhibit.  But the 
purpose and use-cases for btrfs raid1 are different as well.  For my 
particular use-case of checksummed file integrity and ensuring /some/ 
copy of the data survived, and since I had tested and found this behavior 
BEFORE actual deployment, I not entirely happily accepted it.  I'm not 
happy with it, but at least I found out about it in my pre-testing, and 
could adapt my recovery practices accordingly.

But that /does/ mean one can't as simply just pull a device from a 
running raid, then plug it back in and re-add, and expect everything to 
just work, as one could do (and I tested!) with mdraid.  One must be 
rather more careful with btrfs raid, at least at this point, unless of 
course the object is to test full restore procedures as well!

OTOH, from a more philosophical perspective mult-device mdraid handling 
has been around for rather longer than multi-device btrfs, and I did see 
mdraid markedly improve in the years I used it.  I expect btrfs raid 
handling will be rather more robust and mature in another decade or so, 
too, and I've already seen reasonable improvement in the six or eight 
months I've been using it (and the 6-8 months before that too, since when 
I first looked at btrfs I decided it simply wasn't mature enough for me 
to run, yet, so I kicked back for a few months and came at it again). =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

