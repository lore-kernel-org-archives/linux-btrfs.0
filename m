Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39174 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab2IQKAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 06:00:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TDY7Y-0003VO-8d
	for linux-btrfs@vger.kernel.org; Mon, 17 Sep 2012 12:00:04 +0200
Received: from 50C58B65.flatrate.dk ([80.197.139.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 12:00:04 +0200
Received: from casper.bang by 50C58B65.flatrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 12:00:04 +0200
To: linux-btrfs@vger.kernel.org
From: Casper Bnag <casper.bang@gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Date: Mon, 17 Sep 2012 09:55:47 +0000 (UTC)
Message-ID: <loom.20120917T113953-444@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120917091543.GC29881@charite.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ralf Hildebrandt <Ralf.Hildebrandt <at> charite.de> writes:

> 
> * Casper Bang <casper.bang <at> gmail.com>:
> 
> > Oracle (Unbreakable) Linux x64 2.6.39-200.29.3.el6uek.x86_64 #1 SMP
> 
> And the btrfs was that from vanilla 2.6.39 (i.e. over a year old)?
> 

We're using the latest available kernel for our Oracle Unbreakable 
Linux 6.3 from Aug 28. We have no other option, since the Oracle database
software needs to run on a certified distro. I have no idea how to check 
the version Oracle actually compiles with, only the tools package has 
easy-to-grasp version info.

In any event, I would think it unlikely that the performance differences 
we see is the result of missing performance tweeks - we're talking an order 
of magnitude here and that smells of a design difference.

