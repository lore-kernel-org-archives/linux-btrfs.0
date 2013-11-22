Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35328 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3KVT5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 14:57:46 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F18469A03DD
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 12:57:45 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>, <linux-btrfs@vger.kernel.org>
References: <20131108220135.3802.39092@localhost.localdomain>
 <l5jtgo$6q1$1@ger.gmane.org>
 <20131121233751.5312.13383@localhost.localdomain>
 <l6n6l2$ln6$1@ger.gmane.org>
 <20131122134038.5312.42200@localhost.localdomain>
 <l6oche$7sa$1@ger.gmane.org>
In-Reply-To: <l6oche$7sa$1@ger.gmane.org>
Message-ID: <20131122195729.5312.20671@localhost.localdomain>
Subject: Re: progs integration branch moved to master (new default leafsize)
Date: Fri, 22 Nov 2013 14:57:29 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Martin (2013-11-22 14:50:17)
> On 22/11/13 13:40, Chris Mason wrote:
> > Quoting Martin (2013-11-22 04:03:41)
> 
> >>  * QA Notice: Package triggers severe warnings which indicate that it
> >>  *            may exhibit random runtime failures.
> >>  * disk-io.c:91:5: warning: dereferencing type-punned pointer will break
> >> strict-aliasing rules [-Wstrict-aliasing]
> >>  * volumes.c:1930:5: warning: dereferencing type-punned pointer will
> >> break strict-aliasing rules [-Wstrict-aliasing]
> >>  * volumes.c:1931:6: warning: dereferencing type-punned pointer will
> >> break strict-aliasing rules [-Wstrict-aliasing]
> > 
> > Does gentoo modify the optimizations from the Makefile?  We actually
> > have many strict-aliasing warnings, but I didn't think they came up
> > until -O2.
> 
> For that system, I have -Os set in the Gentoo "make.conf".
> 
> 
> > At any rate, I'm adding -fno-strict-aliasing just to be sure.
> 
> Good to catch to avoid unexpectedness,

Ok, please try with the current master to make sure the options are
being picked up properly.  If you're overriding the
-fno-strict-aliasing, please don't ;)

-chris
