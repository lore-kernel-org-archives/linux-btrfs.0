Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44253 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbFYEHF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 00:07:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z7yRL-0008My-Is
	for linux-btrfs@vger.kernel.org; Thu, 25 Jun 2015 06:07:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 06:07:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 06:07:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/2] btrfs device remove alias
Date: Thu, 25 Jun 2015 04:06:54 +0000 (UTC)
Message-ID: <pan$aa275$4c7e2262$e0ed9a01$2b442c12@cox.net>
References: <cover.1435161735.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Omar Sandoval posted on Wed, 24 Jun 2015 09:09:15 -0700 as excerpted:

> The opposite of btrfs device add is btrfs device delete. This really
> should be btrfs device remove.

What about btrfs device subtract?  That's what _I_'d call the opposite of 
add.  Otherwise, add/remove instead of add/delete seems fine to me. Six 
of one, half dozen of the other.  [shrug]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

