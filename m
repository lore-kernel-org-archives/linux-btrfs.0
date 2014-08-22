Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45333 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVSKO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 14:10:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKtHo-0004X6-Td
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 20:10:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 20:10:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 20:10:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Distro vs latest kernel for BTRFS?
Date: Fri, 22 Aug 2014 18:09:51 +0000 (UTC)
Message-ID: <pan$41e33$d9a65aff$7440271d$d5dff35b@cox.net>
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
	<53F731BC.6000200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Fri, 22 Aug 2014 08:04:12 -0400 as
excerpted:

> On 2014-08-22 07:59, Shriramana Sharma wrote:
>> Hello. I've seen repeated advices to use the latest kernel. While
>> hearing of the recent compression bug affecting recent kernels does
>> somewhat warn one off the previous advice, I would like to know what
>> people who are running regular distros do to get the latest kernel.
>> 
>> Personally I'm on Kubuntu, which provides mainline kernels till a
>> particular point but not beyond that.
>> 
>> Do people here always compile the latest kernel themselves just to get
>> the latest BTRFS stability fixes (and  improvements, though as a second
>> priority)?
>> 
> I personally use Gentoo Unstable on all my systems, so I build all my
> kernels locally anyway, and stay pretty much in-line with the current
> stable Mainline kernel.
> Interestingly, I haven't had any issues related to either of the
> recently discovered bugs, despite meeting all of the criteria for being
> affected by them.

Semantics but FWIW some people prefer for that to be called testing, not 
unstable.  Gentoo doesn't have an official whole-tree unstable level, tho 
in effect that's what you get if you enable the various project overlays 
and unmask the non-live packages, so one could say it's per-project or 
per-package.

But of course without an official unstable level, the distinction between 
testing and unstable is rather blurred, so some people call it unstable, 
as opposed to stable, too.  But some don't like the "unstable" 
connotation, and technically, it /is/ closer to Debian's "testing" than 
their "unstable", and I don't know anyone else using the "unstable" 
label, so...

Meanwhile, while I'm on gentoo as well, I've been configuring and 
building my own kernels since shortly after I switched to Linux 
(Mandrake, at the time) instead of MS eXPrivacy, which I refused to do on 
principle.  As a matter of fact, while I had done a bit of experimenting 
before and had taken some time researching the switch, I began my big 
switch for real the week eXPrivacy came out.  After a decade on MS, my 
feelings were with FLOSS but my experience was all on MS so I honestly 
don't know when/if I would have switched without the eXPrivacy line I 
simply wasn't going to cross as a push from MS, so ironically I have MS 
to thank for pushing me to freedomware. =:^)

Anyway, unlike Marc Merlin by the time I switched to Linux you weren't 
expected to build your own kernel, but I learned it within the first 
three months as I was still dual booting and switching one task after 
another to my new Linux platform.  I learned because as a critical part 
of my freedomware platform it was important to me to do so.  And I've 
been building my own kernel, using a set of scripts I've maintained[1] 
over the years to do so, since then.  When I switched to gentoo, I simply 
took the scripts I already had with me, changing them slightly for the 
new environment, as I hadn't setup the separate config file I use these 
days.

These days I fetch, configure and build directly from Linus' git repo, 
still using my scripts set to help me do so. =:^)

While you may not consider Gentoo a "normal distro", presumably you 
consider Mandriva such a distro, it being the successor to the Mandrake 
on which I started doing my own kernel builds.

---
[1] Scripts I've maintained:  FWIW, I learned bash/shell by tearing apart 
and recoding the Mandrake initscripts, getting a practical understanding 
of shell scripting as actually used on a system in the process.  To me, 
tho I've switched to systemd that's arguably the biggest loss of doing 
so, as newbies no longer have the opportunity to bootstrap their own 
shell and shell-scripting knowledge on the scripts the system itself 
bootstraps with. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

