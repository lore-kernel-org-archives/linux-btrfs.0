Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57427 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab3JWUGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 16:06:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VZ4h7-0007WI-JN
	for linux-btrfs@vger.kernel.org; Wed, 23 Oct 2013 22:06:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 22:06:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 22:06:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.11 and 3.12rc continual hard lock ups
Date: Wed, 23 Oct 2013 20:05:56 +0000 (UTC)
Message-ID: <pan$25541$f418e909$cc987052$5cb75c17@cox.net>
References: <CAHCKNJj2=qfWEpWWUOBit5cJakwd+oFr1U-xj8MS-w9oQo6YQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sean Clarke posted on Wed, 23 Oct 2013 20:26:15 +0100 as excerpted:

> I have looked in bugzilla and can't relate this to anything already
> reported, has anyone seen something similar to this?

I don't do NFS so didn't pay attention to the details, but look here on-
list as IIRC there was a very similar NFS-on-btrfs-related bug reported 
recently.  I /believe/ there's a fix in the pipeline, hopefully pre-3.12 
release, but it's only in the last couple days so probably isn't in 
Linus' tree yet.

Do look tho, as I neither remember the details nor am 100% positive that 
what I think I recall is correct, but hopefully this at least lets you 
know to look.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

