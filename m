Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42182 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbFZEV4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 00:21:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z8L9A-0002rn-HU
	for linux-btrfs@vger.kernel.org; Fri, 26 Jun 2015 06:21:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 06:21:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 06:21:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/2] btrfs device remove alias
Date: Fri, 26 Jun 2015 04:21:43 +0000 (UTC)
Message-ID: <pan$8773$4ae88d92$9e16c06b$550d1efe@cox.net>
References: <cover.1435161735.git.osandov@fb.com>
	<558CA6A0.20401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Fri, 26 Jun 2015 09:10:56 +0800 as excerpted:

> while on this. its also good idea to create alias for
> 
>    btrfs replace start -> btrfs device replace.
> 
> any comments ?

That's actually the one that makes more sense to me.  Delete/remove/
subtract, all about the same to me, so while I'm not opposed to alias for 
that, I don't really see the need.  But with btrfs device add/remove, 
having btrfs replace instead of btrfs device replace, makes absolutely no 
sense to me, so I'm all for that alias.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

