Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42176 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbbLJD1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 22:27:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6rtP-0008R5-0K
	for linux-btrfs@vger.kernel.org; Thu, 10 Dec 2015 04:27:43 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 04:27:42 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 04:27:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Missing half of available space (resend)
Date: Thu, 10 Dec 2015 03:27:36 +0000 (UTC)
Message-ID: <pan$b5bdb$fb739c20$bb4bafc8$41b6b38d@cox.net>
References: <1449637341.20669.0.camel@love2code.net>
	<CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
	<1449642609.20669.7.camel@love2code.net>
	<pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
	<1449682081.7150.0.camel@dhampton.net>
	<CAJCQCtSuEQRVsrLim9AD3di7Rxv2xA9FOd872pNXs-CRiFZpcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 09 Dec 2015 12:39:01 -0700 as excerpted:

> On Wed, Dec 9, 2015 at 10:28 AM, David Hampton
> <mailinglists@dhampton.net> wrote:
>> On Wed, 2015-12-09 at 16:48 +0000, Duncan wrote:
>>> David Hampton posted on Wed, 09 Dec 2015 01:30:09 -0500 as excerpted:
>>>
>>> > Seems I need to upgrade my tools.  That command was added in 3.18
>>> > and I only have the 3.12 tools.
>>>
>>> Definitely so, especially because you're running raid6, which wasn't
>>> stable until 4.1 for both kernel and userspace.  3.12?  I guess it did
>>> have the very basic raid56 support, but it's definitely nothing I'd
>>> trust, at that old not for btrfs in general, but FOR SURE not raid56.
>>
>> I've upgraded to the 4.2.0 kernel and the 4.0 btrfs-tools package.
> 
> I think btrfs-progs 4.0 has a mkfs bug in it (or was that 4.0.1?)

Looking at the wiki, it was -progs 4.1.1 that had the mkfs.btrfs bug, 
with 4.1.2 being the urgent bug-fix for it.  (I just looked that up 
myself for a different thread, a couple days ago, so had it fresh and 
knew what I was looking for.)

https://btrfs.wiki.kernel.org/index.php/Changelog#btrfs-
progs_4.1.1_.28Jul_2015.29

> Anyway, even that is still old in Btrfs terms. I think Ubuntu needs to
> do better than this, or just acknowledge Btrfs is not supported, don't
> include btrfs-progs at all by default, and stop making it an install
> time option.

Three points related to list vs. distro release version support here:

1) In terms of this list, as a general rule there's currently four 
recommended kernel series at any point in time.  The latest two series 
from either the current or LTS support series.  On current, 4.4 is 
getting close to release, so 4.3 and 4.2 are generally supported.  On LTS, 
again 4.4 will be an LTS series, with the previous two LTS series being 
4.1 and 3.18, so those are generally supported.  But 3.18 is getting a 
bit long in the tooth now and 4.4 will be another LTS series, so people 
still on it should already be planning their upgrade to at least 4.1.

For userspace (btrfs-progs), daily usage version isn't as critical as the 
kernel, but if there's problems you'll probably want the newest, since it 
has the latest fixes and the best chance for fixing things.  As a general 
rule of thumb, however, the kernel and userspace version numbers are 
series-synced and developed at the same time with the same issues in 
mind, so try to keep userspace version series at least equal to kernel 
series, which if you're following kernel recommendations above, will 
ensure that userspace doesn't get /too/ outdated and that it's roughly in 
sync with your kernel.  Newer userspace than kernel is fine.  Which means 
a 3.18 series userspace at the oldest, as well.

2) While that's the general rule, btrfs raid56 mode was only nominally 
complete (earlier versions of raid56 had runtime completion, but recovery 
tooling was incomplete, so you were effectively running a slow raid0 in 
terms of recovery, that would be updated "for free" when the recovery 
tools were complete) with 3.19 and there were major bugs into early 4.1.

So for raid56 mode you really *NEED* at least the latest LTS 4.1 kernel, 
and following the userspace rule of thumb, the corresponding latest 4.1 
series userspace, 4.1.2, with the bugfix for that mkfs.btrfs bug 
mentioned above.  That's the absolute minimum I'd consider reasonable 
with raid56 mode, as before that, there ARE known bugs and it's simply 
not worth the risk running btrfs raid56 mode on older, period.

However, with btrfs raid56 mode completion still so new, it really can't 
be considered as stable as btrfs in general, with btrfs itself still 
"stabilizing, but not fully stable or mature yet, so be sure you have 
backups available if you value your data."  I've long suggested that 
btrfs raid56 mode would take a year (effectively five kernel series) to 
stabilize after nominal code completion, before I'd consider it as stable 
as btrfs in general.  As it happens, that's 4.4, which is an LTS series 
as well, so the timing is pretty sweet.

But that means as a practical matter, people running btrfs raid56 mode 
have even more reason to be on the very latest, into the coming 4.4 
series at least, because until then, it really can't be considered as 
stable as btrfs in general.  So while 4.1 is the absolute minimum I'd 
consider running with raid56, you /really/ should be on the latest 4.3.x 
stable kernel and 4.3.1 btrfs-progs userspace, and upgrade to 4.4 series 
reasonably soon after it comes out as well.  With 4.4 kernel being an LTS, 
at that point you can relax a bit and stay on that series for awhile, if 
desired.

3) Ubuntu unfortunately has a way of picking kernel versions to 
standardize on, that aren't upstream kernel LTS versions.  As a result, 
while 3.18 for example, was an upstream LTS, the 3.19 ubuntu chose to 
standardize on, was not.  Fortunately, they've announced that they'll 
standardize on the upcoming 4.4 LTS series for 2016.04, so hopefully 
they've seen the light now and will sync a bit better with upstream LTS 
than they have been doing.

The less distro-specific version of this point is that while the above 
two latest current kernel and lts kernel series (and corresponding rule 
of thumb userspace version syncing) recommendations stand for this list, 
distros have their own kernel and userspace support rules, and to the 
extent that they choose to support btrfs but diverge from the above 
general list recommendations, users have a choice, they can either follow 
their distro and presumably rely on the distro for primary btrfs support, 
or follow list recommendations.

Meanwhile, it's not that the list won't try to support versions not in 
sync with list recommendations, we'll certainly try, but that we'll have 
a harder time doing so, because as those versions age, they get further 
from the versions we're immediately familiar with.  So we'll do our best, 
but it's not going to be to the level we'd be able to support recommended 
versions, and at times the best recommendation will be to upgrade to 
something better supported and see what the results are.

As for level of distro support where their recommended versions differ 
from those of this list and upstream, many of them do backport patches 
from current where they consider appropriate, so in fact they _may_ have 
a reasonably stable supported version, outside of upstream's recommended 
versions.  But the point is, that's their choice and their business, and 
people on the list aren't likely to be particularly familiar with what 
particular patches a distro has backported for their various releases, so 
again, we won't be able to provide the level of support we could with 
recommended versions as to some extent the distro packaged releases are 
unknown quantities.  Which is why in that case primary support really 
should come from the distro.  As to how well they actually provide it... 
well, that's between the distro and its users, and isn't really a matter 
this list is directly involved in, as we're btrfs kernel and userspace 
upstream.


So in summary:

1) List primary support: Latest two upstream current and LTS kernel 
release series, with userspace at least kernel-series-synced if not newer.

2) Btrfs raid56 mode is new and not yet as stable as btrfs in general.  
LTS 4.1 series is the absolute minimum acceptable for base support, 
current is preferred, thru at least the soon to be release 4.4 LTS, which 
should stabilize raid56 to roughly the same level as btrfs in general.

3) Distros have their own release support models and users are free to 
choose them for primary support over this list, but where distro support 
series differ from those of this list, we'll still try to provide 
support, but it'll be degraded compared to that provided to primary 
supported release series, and the best list recommendation at times is 
very likely to simply be, upgrade to something we can better support.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

