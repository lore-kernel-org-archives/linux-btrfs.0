Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57912 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423002Ab3CVUtf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 16:49:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3325C7C0435
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 14:49:35 -0600 (MDT)
Date: Fri, 22 Mar 2013 16:49:32 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130322204932.GE1955@localhost.localdomain>
References: <20130321180020.30044.84729@localhost.localdomain>
 <967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag>
 <20130321190249.30044.79438@localhost.localdomain>
 <514B62A4.1030201@profihost.ag>
 <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag>
 <514C4A8C.90607@profihost.ag>
 <20130322135322.GB1955@localhost.localdomain>
 <514C6319.7030400@profihost.ag>
 <20130322155453.GD1955@localhost.localdomain>
 <514CAC8D.7010409@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <514CAC8D.7010409@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 22, 2013 at 01:10:05PM -0600, Stefan Priebe wrote:
> Hi Josef,
> Am 22.03.2013 16:54, schrieb Josef Bacik:
> > On Fri, Mar 22, 2013 at 07:56:41AM -0600, Stefan Priebe - Profihost AG wrote:
> >> Hi Josef,
> >> Am 22.03.2013 14:53, schrieb Josef Bacik:
> >>> On Fri, Mar 22, 2013 at 06:11:56AM -0600, Stefan Priebe - Profihost AG wrote:
> >>>> Hi Chris,
> >>>>
> >>>>>>>>> Which kernel are you running?
> >>>>>>>>>
> >>>>>>>>> -chris
> >>>>>>>>
> >>>>>>>> vanilla 3.8.3.
> >>>>>>>
> >>>>>>> Ok, with the 3.9 merge window Josef changed how we do the reservations.
> >>>>>>> Are you able to try a slightly more experimental kernel?
> >>>>
> >>>> any ideas what i can check? 3.9-rc3 gives me same results.
> >>>>
> >>>
> >>> Sorry Stefan I'm almost done with what I'm working on and then I'll work up a
> >>> patch for you to run so I can narrow down what's going on.  Thanks,
> >>
> >> Great!
> >>
> >> Thanks - just wanted to know that it's not my fault. I'm happy to test
> >> the patch and provide feedback.
> >>
> > Ok I think we are way over-reserving for rename, can you give this patch a whirl
> > and see what happens?  If it still fails can you capture dmesg and reply with
> > that so I can see what's going on.  Thanks,
> 
> Thanks for the patch. I was able to copy some files and i'm still able 
> put it copy some then fails on some then copies some then fails on some.
> 

Ok so I've been working on another ENOSPC related problem that I think is
affecting you as well.  So I'm going to nail that down and see if that helps you
too, if not we'll poke around your problem some more and try and work out what's
happening.  I'll get back to this fresh Monday morning.  Thanks,

Josef
