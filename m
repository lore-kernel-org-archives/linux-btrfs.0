Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:54652 "EHLO
	okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbcGFNFb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 09:05:31 -0400
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55] helo=mother.pipebreaker.pl)
	by okda.pipebreaker.pl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.87)
	(envelope-from <tomek@pipebreaker.pl>)
	id 1bKmH7-0011JX-HO
	for linux-btrfs@vger.kernel.org; Wed, 06 Jul 2016 14:49:57 +0200
Date: Wed, 6 Jul 2016 14:49:54 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 64-btrfs.rules and degraded boot
Message-ID: <20160706124954.GA307667@mother.pipebreaker.pl>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
 <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 06, 2016 at 02:55:37PM +0300, Andrei Borzenkov wrote:
> On Wed, Jul 6, 2016 at 2:45 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2016-07-06 05:51, Andrei Borzenkov wrote:
> >>
> >> On Tue, Jul 5, 2016 at 11:10 PM, Chris Murphy <lists@colorremedies.com>
> >> wrote:
> >>>
> >>> I started a systemd-devel@ thread since that's where most udev stuff
> >>> gets talked about.
> >>>
> >>>
> >>> https://lists.freedesktop.org/archives/systemd-devel/2016-July/037031.html
> >>>
> >>
> >> Before discussing how to implement it in systemd, we need to decide
> >> what to implement. I.e.
> >>
> >> 1) do you always want to mount filesystem in degraded mode if not
> >> enough devices are present or only if explicit hint is given?
> >> 2) do you want to restrict degrade handling to root only or to other
> >> filesystems as well? Note that there could be more early boot
> >> filesystems that absolutely need same treatment (enters separate
> >> /usr), and there are also normal filesystems that may need be mounted
> >> even degraded.
> >> 3) can we query btrfs whether it is mountable in degraded mode?
> >> according to documentation, "btrfs device ready" (which udev builtin
> >> follows) checks "if it has ALL of it’s devices in cache for mounting".
> >> This is required for proper systemd ordering of services.
> >
> >
> > To be entirely honest, if it were me, I'd want systemd to fsck off.  If the
> > kernel mount(2) call succeeds, then the filesystem was ready enough to
> > mount, and if it doesn't, then it wasn't, end of story.
> 
> How should user space know when to try mount? What user space is
> supposed to do during boot if mount fails? Do you suggest
> 
> while true; do
>   mount /dev/foo && exit 0
> done
> 
> as part of startup sequence? And note that nowhere is systemd involved so far.

  Getting rid of such loops was the original motivation for the ioctl:
http://www.spinics.net/lists/linux-btrfs/msg17372.html

  Maybe the ioctl need extending? Instead of returning 1/0, it could
take flag saying ”return 1 as soon as degraded mount is possible”?
  
-- 
Tomasz Torcz                 Morality must always be based on practicality.
xmpp: zdzichubg@chrome.pl                -- Baron Vladimir Harkonnen

