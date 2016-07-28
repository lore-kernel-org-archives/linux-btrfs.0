Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56625 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917AbcG1R0D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 13:26:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bSp4J-0007Ra-Tp
	for linux-btrfs@vger.kernel.org; Thu, 28 Jul 2016 19:26:00 +0200
Received: from ip-64-134-228-15.public.wayport.net ([64.134.228.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 19:25:59 +0200
Received: from 1i5t5.duncan by ip-64-134-228-15.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 19:25:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi defrag does not defrag files >256kB?
Date: Thu, 28 Jul 2016 17:25:53 +0000 (UTC)
Message-ID: <pan$650d6$3849d593$f6774951$ae97703b@cox.net>
References: <pan$acc$75dc71b8$532c7a5c$47aab598@cox.net>
	<CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>
	<20160728105555.GR30795@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Thu, 28 Jul 2016 12:55:55 +0200 as excerpted:

> On Wed, Jul 27, 2016 at 01:19:01PM -0400, Nicholas D Steeves wrote:
>> > In that regard a defrag -t 32M recommendation is reasonable for a
>> > converted filesystem, tho you can certainly go larger... to 1 GiB as
>> > I said.

And... I see that the progs v4.7-rc1 release has the 32M default.

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

