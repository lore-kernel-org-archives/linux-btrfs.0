Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36535 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbcDSIPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 04:15:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1asQor-0006Oh-AE
	for linux-btrfs@vger.kernel.org; Tue, 19 Apr 2016 10:15:37 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 10:15:37 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 10:15:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [resend] btrfs-send -c fails: reproduction case
Date: Tue, 19 Apr 2016 08:15:30 +0000 (UTC)
Message-ID: <pan$b45bb$cc2503a6$7ae51219$d3903fd2@cox.net>
References: <CAC8+__7+ALM5WK-+aCkH0Nc1GUTV5v=7R0SB9LFFE48YM3NLeg@mail.gmail.com>
	<CAJCQCtTh_nDmjf+5MMkHoi6oe4wM51o709m24xZpagT5PMWuQw@mail.gmail.com>
	<CAC8+__7sEnSjtpSSG+Wu+J-582bE4guSwP3L3ZUU8N0r-9ATVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zachary Vance posted on Sun, 17 Apr 2016 18:46:13 -0700 as excerpted:

> I was already making sure all -c references were both present and
> unmodified, I think the confusion is mostly around whether the parent
> required to use -c, and whether it's an implicit reference volume in
> particular. If it's required, it's impossible to preserve de-duplication
> after deleting the original parent which would be really bad.

AFAIK, send -c does require a parent, but if there's clones and no parent 
given, it will try to pick its own from the list of clones given.

Which explains the error complaining about being unable to find a parent, 
when given only clone sources that (based on your reproducer) had nothing 
in common with the snapshots listed as clones.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

