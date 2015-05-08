Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59553 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbbEHKZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 May 2015 06:25:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqfSs-0001gS-H6
	for linux-btrfs@vger.kernel.org; Fri, 08 May 2015 12:25:06 +0200
Received: from p4ff58ffa.dip0.t-ipconnect.de ([79.245.143.250])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 12:25:06 +0200
Received: from holger.hoffstaette by p4ff58ffa.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 12:25:06 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: btrfs scrub under linux with ck-patchset - oops
Date: Fri, 8 May 2015 10:25:00 +0000 (UTC)
Message-ID: <pan.2015.05.08.10.25.00@googlemail.com>
References: <20150508101002.GA3945@sune>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 08 May 2015 11:10:02 +0100, Leonidas Spyropoulos wrote:

> Does anyone experience issues with I/O intensive operations using btrfs
> and BFQ io scheduler? I had a kernel panic while running (almost at the
> start) a scrub and I glimpsed the elevator.c filename on the kernel dump
> before I had to hard-reset.

You may want to check the BFQ list, specifically [1]. It seems to be a
bug in BFQ itself and unrelated to btrfs.

-h

[1] https://groups.google.com/forum/#!topic/bfq-iosched/3T0t2JWl3bk


