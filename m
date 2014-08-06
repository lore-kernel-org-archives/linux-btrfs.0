Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59104 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbaHFAFf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 20:05:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XEoj0-0007WH-3K
	for linux-btrfs@vger.kernel.org; Wed, 06 Aug 2014 02:05:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 02:05:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 02:05:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC with mkdir and rename
Date: Wed, 6 Aug 2014 00:04:22 +0000 (UTC)
Message-ID: <pan$e7996$8cc44d40$452539c$35ab87@cox.net>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<1875052.8GFlAMfPzL@quad> <pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
	<5484676.xyTNESz9qN@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Tue, 05 Aug 2014 22:20:33 +1000 as excerpted:

> The Debian installer has BTRFS in a list of filesystems to choose with
> no special notice about it.  I'm thinking of filing a Debian bug
> requesting that they put a warning against it.
> 
> What do people here think?

You already have my general feeling, a warning is still appropriate.

For Debian, I believe it's fair to characterize people running stable as 
relatively conservative.  As such, a warning may be appropriate, but if 
they're actually /that/ conservative, is it needed, or will user's 
natural inclinations to filesystem conservatism be enough, and a btrfs 
warning thus look more serious than it is?

I'd say warn, unless that warning /will/ be seen as "eat your babies" 
level, even when it's more "appropriate care and a regular backup program 
recommended."

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

