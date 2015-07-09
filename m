Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:59362 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbbGIM6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 08:58:20 -0400
Date: Thu, 9 Jul 2015 14:58:17 +0200
From: Sander <sander@humilis.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: sander@humilis.net, "Fajar A. Nugraha" <list@fajar.net>,
        james harvey <jamespharvey20@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Message-ID: <20150709125817.GA29629@panda>
Reply-To: sander@humilis.net
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
 <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
 <559E6411.6090109@gmail.com>
 <20150709124121.GA25033@panda>
 <559E6D80.7010607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <559E6D80.7010607@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn wrote (ao):
> On 2015-07-09 08:41, Sander wrote:
> >Austin S Hemmelgarn wrote (ao):
> >>>What's wrong with "btrfs subvolume snapshot"?
> >>
> >>Well, personally I would say the fact that once something is tagged as
> >>a snapshot, you can't change it to a regular subvolume without doing a
> >>non-incremental send/receive.
> >
> >A snapshot is a subvolume. There is no such thing as "tagged as a
> >snapshot".
> >
> >	Sander
> >
> No, there is a bit in the subvolume metadata that says whether it's
> considered a snapshot or not.  Internally, they are handled identically, but
> it does come into play when you consider things like btrfs subvolume show -s
> (which only lists snapshots), which in turn means that certain tasks are
> more difficult to script robustly.

I stand corrected. Thanks for the info.

	Sander
