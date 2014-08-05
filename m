Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:41112 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbaHEVcP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 17:32:15 -0400
Date: Tue, 5 Aug 2014 14:32:14 -0700
From: Zach Brown <zab@zabbo.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
Message-ID: <20140805213214.GH18659@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be>
 <20140716172021.GA10833@lenny.home.zabbo.net>
 <1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be>
 <20140717190152.GB24196@lenny.home.zabbo.net>
 <20140802142449.15f4cfc2c2821e90e04e175e@skynet.be>
 <20140804183158.GA18659@lenny.home.zabbo.net>
 <2069847253.202465.1407230425329.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <2069847253.202465.1407230425329.open-xchange@webmail.nmp.skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > > Hello Zach,
> > >
> > >     Here's an untested patch which
> >
> > Try testing it.  It's easy with virtualization and xfstests.
> >
> > You'll find that sending to a file fails because each individual file
> > write call that makes up a send starts at offset 0 -- at the start of
> > the file.
> >
> > Getting this right means getting the semantics around updating the send
> > descriptors f_pos right.  It requires having a bit of a think about send
> > semantics and f_pos update locking.
> 
> Thanks for those informations Zach,
> 
> I've tried btrfs test scripts related to ioctl in xfstests (tests/btrfs/025,
> 035, 052, 055)
> but was not able to trigger that problem. Do I have to create another script,
> use some generic one
> or maybe use big test/scratch devices ?

No idea, sorry.  Maybe your patch is fine and I'm a dummy.  Maybe you
didn't test the kernel you thought you were testing.  Maybe the test
doesn't test what you changed.  You'll have to do some investigating to
find out.

- z
