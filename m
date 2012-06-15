Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58671 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247Ab2FOUKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 16:10:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Sfcqi-000546-HB
	for linux-btrfs@vger.kernel.org; Fri, 15 Jun 2012 22:10:28 +0200
Received: from mail1.co.dona-ana.nm.us ([67.134.23.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2012 22:10:28 +0200
Received: from steamraven by mail1.co.dona-ana.nm.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2012 22:10:28 +0200
To: linux-btrfs@vger.kernel.org
From: steamraven <steamraven@yahoo.com>
Subject: Re: KVM on top of BTRFS
Date: Fri, 15 Jun 2012 20:10:18 +0000 (UTC)
Message-ID: <loom.20120615T190819-805@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com> <loom.20120612T013031-188@post.gmane.org> <20120612133311.58af9d8f@natsu> <loom.20120612T162801-407@post.gmane.org> <loom.20120612T222541-400@post.gmane.org> <CAD=4a=XVosacvO1bGm=nGjuakmKhkKFUdJHcjd1MREEV+rqnrA@mail.gmail.com> <loom.20120613T234505-531@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A couple tests have been uploaded to http://openbenchmarking.org/result/1206152-
STEA-VMTESTS05.


Note for the nodatacow, the subvolume did have a snapshot, since the point was 
for VM's that could be snapshoted (either through virsh or btrfs).  Thus the 
first write to a block was cow, but subsequent ones where not.

FY, the tests are not very thorough yet



