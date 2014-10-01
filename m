Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59685 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbaJAXPm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 19:15:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XZT7R-0005PW-H2
	for linux-btrfs@vger.kernel.org; Thu, 02 Oct 2014 01:15:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 01:15:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 01:15:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs progs 3.16.2
Date: Wed, 1 Oct 2014 23:15:25 +0000 (UTC)
Message-ID: <pan$906da$6c7d5d3c$d3bdad8a$75c98e31@cox.net>
References: <20141001164910.GT11436@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Wed, 01 Oct 2014 18:49:10 +0200 as excerpted:

> several important fixes appeared recently and the 3.17 branch is not
> finalized so I'm doing another minor release, including nonintrusive
> patches and documentation updates.

In 3.16.1 I looked in vain for documentation for the new balance filter I 
saw in the changelog (for 3.16 or 3.16.1 IDR which, and I'd have to 
lookup the name of the filter...).  I don't see it listed here either.

If it's not in 3.16.2, could the btrfs-balance manpage be updated to 
include it for 3.17?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

