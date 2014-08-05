Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43363 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbaHEIVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 04:21:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XEZzP-0006qZ-3F
	for linux-btrfs@vger.kernel.org; Tue, 05 Aug 2014 10:20:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 10:20:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 10:20:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 5 Aug 2014 08:20:40 +0000 (UTC)
Message-ID: <pan$92d50$cb27b892$f18e750a$667475cd@cox.net>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<53DEE40C.6020403@cn.fujitsu.com>
	<CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
	<17833067.mzxAL4oqZq@quad>
	<CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
	<20140804102206.GA31950@carfax.org.uk>
	<CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>
	<53DFBE43.2050901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Mon, 04 Aug 2014 13:09:23 -0400 as
excerpted:

> Think of each chunk like a box, and each block as a block, and that you
> have two different types of block (data and metadata) and two different
> types of box (also data and metadata). The data boxes are four times the
> size of the metadata boxes, and they all have to fit in one really big
> container (the device itself).  You can only put data blocks in the data
> boxs, and you can only put metadata blocks in metadata boxes.  Say that
> in total, you can fit 128 data boxes in the large container, or you can
> replace one data box with up to four metadata boxes.  Even though you
> may only have a few blocks in a given box, the box still takes up the
> same amount of space in the larger container.  Thus, it's possible to
> have only a few blocks stored, but not be able to add any more boxes to
> the larger container.  A balance operation is essentially the equivalent
> of taking all of the blocks of a given type, and fitting them into the
> smallest number of boxes possible.

FWIW, that's a great analogy to stick up on the wiki somewhere, probably 
somewhere in the FAQ related to ENOSPC.  Please consider doing so.

(Someone took one of my explanations from the list and stuck it in the 
wiki, virtually word-for-word, with a link to the list post in the 
archives for more.  I was glad, as for some reason I just seem to work 
best on the lists, and seem to treat web pages as read-only, even if 
they're on a wiki I in theory have or can get write-privs on.  I'm 
suggesting someone, doesn't have to be you tho great if it is, do the 
same with this.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

