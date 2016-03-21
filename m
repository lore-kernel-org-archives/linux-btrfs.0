Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbcCUJzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 05:55:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ahwYg-0001AA-2u
	for linux-btrfs@vger.kernel.org; Mon, 21 Mar 2016 10:55:34 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:55:34 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:55:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: overlay file to test btrfs repairs
Date: Mon, 21 Mar 2016 09:55:23 +0000 (UTC)
Message-ID: <pan$2fe7d$1410eb30$c926ea8c$aa8d1cf9@cox.net>
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 20 Mar 2016 21:43:52 -0600 as excerpted:

> Hi folks,
> 
> So I just ran into this:
> https://raid.wiki.kernel.org/index.php/
Recovering_a_failed_software_RAID#Making_the_harddisks_read-
only_using_an_overlay_file

[That's a single link, wrapped by my client.]
 
> This is a device mapper overlay file - not overlayfs.
> 
> For the repairs that are sometimes uncertain what's next, maybe this is
> a viable option to avoid changing the file system? I'm thinking
> chunk-recover might take up too much space, I'm not sure how that one
> works, if chunks are just being read or if they have to be rewritten or
> if it's just the chunk tree? But for 'btrfs check' and 'btrfs rescue
> super-recover/zero-log' there should be very little being written so the
> overlay idea might be a good step?
> 
> Opinions?

That's a creative and potentially quite useful possible solution to an 
often hairy problem.  Thanks for bringing it up. =:^)

Provided Hugo and the devs don't find major fault with the idea, linking 
that from appropriate locations (as a possible solution in the Problem 
FAQ is the first one that occurs to me) in the btrfs wiki could be quite 
useful, to many.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

