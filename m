Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35110 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbaK3Gqv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 01:46:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XuyHR-0003Qb-H8
	for linux-btrfs@vger.kernel.org; Sun, 30 Nov 2014 07:46:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 07:46:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 07:46:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Sun, 30 Nov 2014 06:46:39 +0000 (UTC)
Message-ID: <pan$af4b1$cf878453$a8daece6$4af86759@cox.net>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net> <54764F4E.80405@pobox.com>
	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
	<CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com>
	<pan$40148$39c282ee$365818$9e1ebdba@cox.net> <547981BB.7030206@pobox.com>
	<5479F971.3030607@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Sat, 29 Nov 2014 08:50:57 -0800 as excerpted:

> To those reading along who don't already know. My explanation below is
> factually inadequate or wrong in various places...
> 
> The "type codes" as presented in the various EFI/GUID disk partitioning
> tools as 0700, 8200, 8300, EF02, and so on are never written to disk as
> such. They are short-hand values (chosen to be deliberately similar to
> the MS-DOS partitioning type codes of 07, 82, 83, etc) to select
> standardized GUIDs for the partition type field.

> I could have, and should have, been _way_ more clear, and/or less wrong.
> 8-)
> 
> http://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs

Thanks.

While I guess we all end up eat humble pie occasionally, you handled it 
with more rather more grace that I often do, and by taking such a hard 
line myself I didn't make it as easy as I might have.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

