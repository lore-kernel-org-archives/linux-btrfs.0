Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55048 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaFOFCt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 01:02:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ww2ad-0006iI-NF
	for linux-btrfs@vger.kernel.org; Sun, 15 Jun 2014 07:02:47 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 07:02:47 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 07:02:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sun, 15 Jun 2014 05:02:34 +0000 (UTC)
Message-ID: <pan$ad44b$2c1071b2$aca734b5$a4151968@cox.net>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<pan$22693$6b452195$976b783a$e4956372@cox.net>
	<20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it>
	<pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
	<jhmt6b-j4j.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sat, 14 Jun 2014 12:59:31 +0200 as excerpted:

> Duncan <1i5t5.duncan@cox.net> schrieb:
> 
>> As they say, "Whoosh!"
>> 
>> At least here, I interpreted that remark as primarily sarcastic
>> commentary on the systemd devs' apparent attitude, which can be
>> (controversially) summarized as: "Systemd doesn't have problems because
>> it's perfect.  Therefore, any problems you have with systemd must
>> instead be with other components which systemd depends on."
> 
> Come on, sorry, but this is fud. Really... ;-)

I should make clear that did recently switch to systemd myself -- by 
choice as I'm on gentoo and it defaults to openrc, so I'm obviously not 
entirely anti-systemd.  And I _did_ say "(controversially)", which means 
I do recognize that there are two sides to the story.

That said, I've certainly seen what happens when non-systemd devs are on 
the receiving end of things -- including kernel devs, see the recent 
hubbub over the debug kernel commandline option and the somewhat longer 
ago firmware loading issue, among others.

But sarcasm implies neither absolute truth, or it'd be speaking truth not 
sarcasm, nor absolute untruth, because without a kernel of truth there 
it'd be simply stupid, not sarcastic.

And certainly that's how I read the comment.

But in any case, I read it as not to be taken literally, which is what it 
appeared to me the person to which I was directly replying was doing.  I 
was simply warning him off of reading it too literally as at least from 
here, it seemed more like sarcasm.

Of course if DaveC wishes to clarify one way or another he certainly 
can... tho I'd not expect it at this point since if it is sarcasm as I 
believe, that's kind of having to explain the joke...

> I think that systemd is even one of the early supporters of btrfs
> because it will defragment readahead files on boot from btrfs. I'd
> suggest the problem is to be found in the different semantics with COW
> filesystems.

Which is actually what I was saying.  In reality it's an interaction 
between the nature of COW filesystems, where fallocate tends to be a 
problem, and an application using fallocate because of its benefits on 
overwrite-in-place filesystems, which happen to be the norm at this 
point.  So neither one is to blame, it's simply a bad interaction that 
ultimately needs to be made better on one side or the other.

But btrfs is still relatively young and COW-based filesystems not that 
widespread yet, so that the problem hasn't been worked out to be handled 
automatically, just yet, isn't a big surprise.  Tho I think it'll come.

Meanwhile, as you point out below and as I've repeatedly said in this 
thread already myself, NOCOW and/or autodefrag are tools available to an 
admin faced with the problem, that together actually solve it reasonably 
well.  All an admin has to do is make use of the tools already available. 
=:^)

> So let's start with my journals, on btrfs:
> 
> $ sudo filefrag *
> system@0004fad12dae7676-98627a3d7df4e35e.journal~: 2 extents found
> system@0004fae8ea4b84a4-3a2dc4a93c5f7dc9.journal~: 2 extents found
> 
system@806cd49faa074a49b6cde5ff6fca8adc-000000000008e4cc-0004f82580cdcb45.journal:
> 5 extents found
> 
system@806cd49faa074a49b6cde5ff6fca8adc-0000000000097959-0004f89c2e8aff87.journal:
> 5 extents found
> 
system@806cd49faa074a49b6cde5ff6fca8adc-00000000000a166d-0004f98d7e04157c.journal:
> 5 extents found
> 
system@806cd49faa074a49b6cde5ff6fca8adc-00000000000aad59-0004fa379b9a1fdf.journal:
> 5 extents found
> 
system@ec16f60db38f43619f8337153a1cc024-0000000000000001-0004fae8e5057259.journal:
> 5 extents found
> 
system@ec16f60db38f43619f8337153a1cc024-00000000000092b1-0004fb59b1d034ad.journal:
> 5 extents found system.journal: 9 extents found
> 
user-500@e4209c6628ed4a65954678b8011ad73f-0000000000085b7a-0004f77d25ebba04.journal:
> 2 extents found
> 
user-500@e4209c6628ed4a65954678b8011ad73f-000000000008e7fb-0004f83c7bf18294.journal:
> 2 extents found
> 
user-500@e4209c6628ed4a65954678b8011ad73f-0000000000097fe4-0004f8ae69c198ca.journal:
> 2 extents found
> 
user-500@e4209c6628ed4a65954678b8011ad73f-00000000000a1a7e-0004f9966e9c69d8.journal:
> 2 extents found user-500.journal: 2 extents found
> 
> I don't think these are too bad values, eh?
> 
> Well, how did I accomblish that?
> 
> First, I've set the journal directories nocow. Of course, systemd should
> do this by default. I'm not sure if this is a packaging or systemd code
> issue,
> tho. But I think the systemd devs are in common that for cow fs, the
> journal directories should be set nocow. After all, the journal is a
> transactional database - it does not need cow protection at all costs.
> And I think they have their own checksumming protection. So, why let
> systemd bother with that? A lot of other software has the same semantic
> problems with btrfs, too (ex. MySQL) where nobody shouts at the
> "inabilities" of the programmers. So why for systemd? Just because it's
> intrusive by its nature for being a radically and newly designed init
> system and thus requires some learning by its users/admins/packagers?
> Really? Come on... As admin and/or packager you have to stay with
> current technologies and developments anyways. It's only important to
> hide the details from the users.
> 
> Back to the extents counts: What I did next was implementing a defrag
> job that regularly defrags the journal (actually, the complete log
> directory as other log files suffer the same problem):
> 
> $ cat /usr/local/sbin/defrag-logs.rb #!/bin/sh exec btrfs filesystem
> defragment -czlib -r /var/log
> 
> It can be easily converted into a timer job with systemd. This is left
> as an excercise to the reader.
> 
> BTW: Actually, that job isn't currently executed on my system which
> makes the numbers above pretty impressive... However, autodefrag is
> turned on which may play into the mix. I'm not sure. I stopped
> automatically running those defrag jobs a while ago (I have a few more).

Thanks for the timer hint, BTW.  I actually already created an hourly and 
a daily timer job here (turns out that's all I needed, no weekly/monthly/
whatever needed so I didn't create those) as I switched over to systemd 
and got rid of crond, and I'll definitely keep the defrag-journals timer 
idea up my sleeve in case I decide to set journald back to keeping non-
volatile journals as well, plus as a helpful hint for others.  Tho I 
won't be using it myself currently as the volatile journals only while 
handing off to syslog-ng for the longer term logs is working very well 
for me ATM, a good sysadmin likes to have a set of tricks such as that 
ready in case they're needed, and I'm certainly no exception! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

