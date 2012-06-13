Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43490 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2FMVrm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 17:47:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SevPd-0008QE-2x
	for linux-btrfs@vger.kernel.org; Wed, 13 Jun 2012 23:47:37 +0200
Received: from mail1.co.dona-ana.nm.us ([67.134.23.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 23:47:37 +0200
Received: from steamraven by mail1.co.dona-ana.nm.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 23:47:37 +0200
To: linux-btrfs@vger.kernel.org
From: steamraven <steamraven@yahoo.com>
Subject: Re: KVM on top of BTRFS
Date: Wed, 13 Jun 2012 21:47:23 +0000 (UTC)
Message-ID: <loom.20120613T234505-531@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com> <loom.20120612T013031-188@post.gmane.org> <20120612133311.58af9d8f@natsu> <loom.20120612T162801-407@post.gmane.org> <loom.20120612T222541-400@post.gmane.org> <CAD=4a=XVosacvO1bGm=nGjuakmKhkKFUdJHcjd1MREEV+rqnrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ernst Sjöstrand <ernstp <at> gmail.com> writes:

> 
> Hi,
> 
> you can't beat the benchmarks that Serge Hallyn did, really thorough!
> 
> http://s3hh.wordpress.com/2012/05/02/first-round-of-kvm-performance-tests/

They do seem very thorough. Unfortunately, they are kvm on top of ext4 and
 he was mainly checking caching parameters and storage formats.  I am 
looking at BTRFS options and comparing them against qcow2 on ext4.

Matt  

