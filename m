Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbbGISd5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 14:33:57 -0400
Date: Thu, 9 Jul 2015 20:33:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: sander@humilis.net, "Fajar A. Nugraha" <list@fajar.net>,
        james harvey <jamespharvey20@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Message-ID: <20150709183355.GA726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
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

On Thu, Jul 09, 2015 at 08:48:00AM -0400, Austin S Hemmelgarn wrote:
> On 2015-07-09 08:41, Sander wrote:
> > Austin S Hemmelgarn wrote (ao):
> >>> What's wrong with "btrfs subvolume snapshot"?
> >>
> >> Well, personally I would say the fact that once something is tagged as
> >> a snapshot, you can't change it to a regular subvolume without doing a
> >> non-incremental send/receive.
> >
> > A snapshot is a subvolume. There is no such thing as "tagged as a
> > snapshot".
> >
> No, there is a bit in the subvolume metadata that says whether it's 
> considered a snapshot or not.

Technically it's not really a bit. The snapshot relation is determined
by the parent uuid value of a subvolume.

> Internally, they are handled identically, 
> but it does come into play when you consider things like btrfs subvolume 
> show -s (which only lists snapshots),

That was probably 'btrfs subvol list -s', though the 'subvol show'
command prints all snapshots of a given subvolume.

> which in turn means that certain 
> tasks are more difficult to script robustly.

I don't deny the interface/output is imperfect for scripting purposes,
maybe we can provide filters that would satisfy your usecase.
