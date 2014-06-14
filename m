Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38832 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbaFNDIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 23:08:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WveK8-0001Hx-CH
	for linux-btrfs@vger.kernel.org; Sat, 14 Jun 2014 05:08:08 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jun 2014 05:08:08 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jun 2014 05:08:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs filesystem read only on error
Date: Sat, 14 Jun 2014 03:07:56 +0000 (UTC)
Message-ID: <pan$c592e$bc1a92a7$ef735cdd$fc66f65b@cox.net>
References: <CA+3u+RfJQ07aci3k=PBO33RNjWzNx6iBZdKaVJ+gGyU44-VrTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Bloquel posted on Fri, 13 Jun 2014 12:51:32 +0200 as excerpted:

> Informations about my system:
> Linux nas1 3.12-0.bpo.1-amd64 #1 SMP Debian 3.12.9-1~bpo70+1
> (2014-02-07)
> x86_64 GNU/Linux brtfs version:
> Btrfs v0.19

Yikes, that's old!  Particularly the 0.19 btrfs-progs, tho there have 
been a lot of kernel btrfs fixes since the 3.12 series as well, not all 
of which will have been backported.

Due to the rate of fixes going into btrfs, users are strongly recommended 
to keep up with current stable kernels, now 3.15, and not get /too/ far 
behind on btrfs-progs either.

I'm actually a bit behind myself ATM as I've been focused on other 
things, kernel from git but not rebuild since 3.14, and btrfs-progs from 
git at v3.14.2.  I'd recommend kernel 3.14 if not 3.15, and a btrfs-progs 
no older than 3.12.  I think there are some snapshotting fixes in kernel 
3.15 so you'll probably want that given the snapshotting you report 
doing.  (I do little snapshotting and 3.14 has been pretty stable for me, 
the reason I've let myself get a bit behind, what with other things I 
have been doing.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

