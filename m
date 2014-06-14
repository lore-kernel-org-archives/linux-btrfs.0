Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42883 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaFNXfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Jun 2014 19:35:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WvxTT-0006fN-SB
	for linux-btrfs@vger.kernel.org; Sun, 15 Jun 2014 01:35:03 +0200
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 01:35:03 +0200
Received: from hurikhan77 by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 01:35:03 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sat, 14 Jun 2014 12:59:31 +0200
Message-ID: <jhmt6b-j4j.ln1@hurikhan77.spdns.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <pan$22693$6b452195$976b783a$e4956372@cox.net> <20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it> <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> As they say, "Whoosh!"
> 
> At least here, I interpreted that remark as primarily sarcastic
> commentary on the systemd devs' apparent attitude, which can be
> (controversially) summarized as: "Systemd doesn't have problems because
> it's perfect.  Therefore, any problems you have with systemd must instead
> be with other components which systemd depends on."

Come on, sorry, but this is fud. Really... ;-)

> IOW, it's a btrfs problem now in practice, not because it is so in a
> technical sense, but because systemd defines it as such and is unlikely
> to budge, so the only way to achieve progress is for btrfs to deal with
> it.

I think that systemd is even one of the early supporters of btrfs because it 
will defragment readahead files on boot from btrfs. I'd suggest the problem 
is to be found in the different semantics with COW filesystems. And if 
someone loudly complains to the systemd developers how bad they are at doing 
their stuff - hmm, well, I would be disapointed/offended, too, as a 
programmer because much very well done work has been put into systemd and 
I'd start ignoring such people. In Germany we have a saying for this: "Wie 
man in den Wald hineinruft, so schallt es heraus." [1] They are doing many 
things right that have not been adopted to modern systems in the last twenty 
years (or so) with the legacy init systems.

So let's start with my journals, on btrfs:

$ sudo filefrag *
system@0004fad12dae7676-98627a3d7df4e35e.journal~: 2 extents found
system@0004fae8ea4b84a4-3a2dc4a93c5f7dc9.journal~: 2 extents found
system@806cd49faa074a49b6cde5ff6fca8adc-000000000008e4cc-0004f82580cdcb45.journal: 
5 extents found
system@806cd49faa074a49b6cde5ff6fca8adc-0000000000097959-0004f89c2e8aff87.journal: 
5 extents found                                                                                                                  
system@806cd49faa074a49b6cde5ff6fca8adc-00000000000a166d-0004f98d7e04157c.journal: 
5 extents found                                                                                                                  
system@806cd49faa074a49b6cde5ff6fca8adc-00000000000aad59-0004fa379b9a1fdf.journal: 
5 extents found
system@ec16f60db38f43619f8337153a1cc024-0000000000000001-0004fae8e5057259.journal: 
5 extents found
system@ec16f60db38f43619f8337153a1cc024-00000000000092b1-0004fb59b1d034ad.journal: 
5 extents found
system.journal: 9 extents found
user-500@e4209c6628ed4a65954678b8011ad73f-0000000000085b7a-0004f77d25ebba04.journal: 
2 extents found
user-500@e4209c6628ed4a65954678b8011ad73f-000000000008e7fb-0004f83c7bf18294.journal: 
2 extents found
user-500@e4209c6628ed4a65954678b8011ad73f-0000000000097fe4-0004f8ae69c198ca.journal: 
2 extents found
user-500@e4209c6628ed4a65954678b8011ad73f-00000000000a1a7e-0004f9966e9c69d8.journal: 
2 extents found
user-500.journal: 2 extents found

I don't think these are too bad values, eh?

Well, how did I accomblish that?

First, I've set the journal directories nocow. Of course, systemd should do 
this by default. I'm not sure if this is a packaging or systemd code issue, 
tho. But I think the systemd devs are in common that for cow fs, the journal 
directories should be set nocow. After all, the journal is a transactional 
database - it does not need cow protection at all costs. And I think they 
have their own checksumming protection. So, why let systemd bother with 
that? A lot of other software has the same semantic problems with btrfs, too 
(ex. MySQL) where nobody shouts at the "inabilities" of the programmers. So 
why for systemd? Just because it's intrusive by its nature for being a 
radically and newly designed init system and thus requires some learning by 
its users/admins/packagers? Really? Come on... As admin and/or packager you 
have to stay with current technologies and developments anyways. It's only 
important to hide the details from the users.

Back to the extents counts: What I did next was implementing a defrag job 
that regularly defrags the journal (actually, the complete log directory as 
other log files suffer the same problem):

$ cat /usr/local/sbin/defrag-logs.rb 
#!/bin/sh
exec btrfs filesystem defragment -czlib -r /var/log

It can be easily converted into a timer job with systemd. This is left as an 
excercise to the reader.

BTW: Actually, that job isn't currently executed on my system which makes 
the numbers above pretty impressive... However, autodefrag is turned on 
which may play into the mix. I'm not sure. I stopped automatically running 
those defrag jobs a while ago (I have a few more).
 
> An arguably fairer and more impartial assessment of this particular
> situations suggests that neither btrfs, which as a COW-based filesystem,
> like all COW-based filesystems has the existing-file-rewrite as a major
> technical challenge that it must deal with /somehow/, nor systemd, which
> in choosing to use fallocate is specifically putting itself in that
> existing-file-rewrite class, are entirely at fault.

This challenge is not only affecting systemd but also a lot of other 
packages which do not play nice with btrfs semantics. But - as you correctly 
write - you cannot point your finger at just one party. FS and user space 
have to come together to evaluate and fix the problems on both sides. In 
> But that doesn't matter if one side refuses to budge, because then the
> other side must do so regardless of where the fault was, if there is to
> be any progress at all.

> Meanwhile, I've predicted before and do so here again, that as btrfs
> moves toward mainstream and starts supplanting ext* as the assumed Linux
> default filesystem, some of these problems will simply "go away", because
> at that point, various apps are no longer optimized for the assumed
> default filesystem, and they'll either be patched at some level (distro
> level if not upstream) to work better on the new default filesystem, or
> will be replaced by something that does.  And neither upstream nor distro
> level does that patching, then at some point, people are going to find
> that said distro performs worse than other distros that do that patching.

> Another alternative is that distros will start setting /var/log/journal
> NOCOW in their setup scripts by default when it's btrfs, thus avoiding
> the problem.  (Altho if they do automated snapshotting they'll also have
> to set it as its own subvolume, to avoid the first-write-after-snapshot-
> is-COW problem.)  Well, that, and/or set autodefrag in the default mount
> options.

> Meanwhile, there's some focus on making btrfs behave better with such
> rewrite-pattern files, but while I think the problem can be made /some/
> better, hopefully enough that the defaults bother far fewer people in far
> fewer cases, I expect it'll always be a bit of a sore spot because that's
> just how the technology works, and as such, setting NOCOW for such files
> and/or using autodefrag will continue to be recommended for an optimized
> setup.


