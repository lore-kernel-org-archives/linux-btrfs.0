Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56692 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab2IQKr4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 06:47:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TDYru-0000jp-It
	for linux-btrfs@vger.kernel.org; Mon, 17 Sep 2012 12:47:58 +0200
Received: from 50C58B65.flatrate.dk ([80.197.139.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 12:47:58 +0200
Received: from casper.bang by 50C58B65.flatrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 12:47:58 +0200
To: linux-btrfs@vger.kernel.org
From: Casper Bnag <casper.bang@gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Date: Mon, 17 Sep 2012 10:47:44 +0000 (UTC)
Message-ID: <loom.20120917T123219-86@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120917091543.GC29881@charite.de> <loom.20120917T113953-444@post.gmane.org> <55422103-3EA7-4DE9-9C47-351CBD006871@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Oracle Database is not certified to run on either btrfs or ZFS on Linux, so if 
certification is an issue, you can't use either filesystem. 

Right, I had missed that - only ZFS on Solaris is officially supported I 
suppose. We had to draw the line somewhere, and an Oracle OS with an Oracle 
database with an Oracle filesystem seemed like a good platform. If the BTRFS 
pieces are indeed a year old in the latest official binary kernel from last 
month, that just makes me wonder why Oracle didn't use these latest bits. 
Again, I'm inclined to think we're dealing with a design difference between 
ZFS and BTRFS rather than a missing performance optimization. You'd know that 
better than I. :)

> Out of interest, have you done a performance benchmark with ASM using ASMlib
> on the same platform? 

Sorry, no. Our experience with ASM is limited, we came to the conclusion once
that we like being able to handle the files in a plain mountable file-system.

