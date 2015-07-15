Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbbGOMB7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 08:01:59 -0400
Date: Wed, 15 Jul 2015 14:01:57 +0200
From: David Sterba <dsterba@suse.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: sander@humilis.net, "Fajar A. Nugraha" <list@fajar.net>,
        james harvey <jamespharvey20@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Message-ID: <20150715120157.GF6306@suse.cz>
Reply-To: dsterba@suse.com
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
 <CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
 <559E6411.6090109@gmail.com>
 <20150709124121.GA25033@panda>
 <559E6D80.7010607@gmail.com>
 <20150709183355.GA726@twin.jikos.cz>
 <559FCA6D.8020800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <559FCA6D.8020800@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 10, 2015 at 09:36:45AM -0400, Austin S Hemmelgarn wrote:
> > Technically it's not really a bit. The snapshot relation is determined
> > by the parent uuid value of a subvolume.
> I'm actually kind of curious, is the parent UUID actually used for 
> anything outside of send/receive?

AFAIK no.

> >> which in turn means that certain
> >> tasks are more difficult to script robustly.
> >
> > I don't deny the interface/output is imperfect for scripting purposes,
> > maybe we can provide filters that would satisfy your usecase.
> >
> Personally, I don't really do much direct scripting of BTRFS related 
> tasks (although that might change if I can convince my boss that we 
> should move to BTRFS for our server systems).  Most of my complaint with 
> the current arrangement is primarily aesthetic more than anything else.

Ok understood, thanks.
