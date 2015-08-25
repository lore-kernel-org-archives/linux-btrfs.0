Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47941 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbbHYWmE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 18:42:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUMul-0007s9-Be
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 00:41:59 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 00:41:59 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 00:41:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Chunk fullness distribution
Date: Tue, 25 Aug 2015 22:41:43 +0000 (UTC)
Message-ID: <pan$bc6b1$ea9ce194$7e96f0e3$c7f01a43@cox.net>
References: <CAEp_DRAR5yjYNm-26jfVmajGqoSt3C9P1L5kS+C9s6g=zZhynQ@mail.gmail.com>
	<pan$3cda0$8efee9f8$3720f4b$2571ee17@cox.net>
	<CAEp_DRBA=591kp3Tpgu0fWCkAJ8+xi7TPBM1nx=UFCgOQ9oLPw@mail.gmail.com>
	<CAEp_DRCwVhWGr8L3=jJ5MH1PTU_VBoN-ieSU1CzRG+-Wbw=g-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bostjan Skufca posted on Tue, 25 Aug 2015 19:52:38 +0200 as excerpted:

> Could please someone comment on this, especially whether I am on
> somewhat correct course, or did I completely miss the interpretation of
> btrfs-debug-tree output values? :)

Since I had replied upthread...

I very much like your histogram and hope that you're on the right track, 
in which case I'd suggest a possibly cleaned up version of your tool 
would be very nice to have in btrfs-progs.  But I'm simply a btrfs-using 
admin and list regular, not a dev, and am beyond my depth in terms of 
being able to judge whether you're actually on the right track or not.

Hopefully one of the devs will comment, and as I said, hopefully we'll 
see a tool doing that in btrfs-progs, soon.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

