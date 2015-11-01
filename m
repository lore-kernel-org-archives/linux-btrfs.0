Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43683 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbKAW5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Nov 2015 17:57:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zt1ZA-0002Ti-GG
	for linux-btrfs@vger.kernel.org; Sun, 01 Nov 2015 23:57:36 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 23:57:36 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 23:57:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared
 subtree during snapshot delete
Date: Sun, 1 Nov 2015 22:57:22 +0000 (UTC)
Message-ID: <pan$5a6ef$2dd4598a$565dd5ea$17edba05@cox.net>
References: <56367AE8.9030509@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe posted on Sun, 01 Nov 2015 21:49:44 +0100 as excerpted:

> this one: http://www.spinics.net/lists/linux-btrfs/msg47377.html
> 
> adds a regression to my test systems with very large disks (30tb and
> 50tb).
> 
> btrfs balance is super slow afterwards while heavily making use of cp
> --reflink=always on big files (200gb - 500gb).
> 
> Sorry didn't know how to correctly reply to that "old" message.

Just on the message-reply bit...

Gmane.org carries this list (among many), archiving the posts with both 
nntp/news and http/web interfaces.  Both the web and news interfaces 
normally allow replies to both old and current messages via the gmane 
gateway forwarding to the list, tho the first time you reply to a list 
via gmane, it'll respond with a confirmation to the email address you 
used, requiring you to reply to that before forwarding the mail on to the 
list.  If you don't reply within a week, the message is dropped.  
However, at least for the news interface (not sure about the web 
interface), you only have to confirm for a particular list/newsgroup 
once, after that, it forwards to the list without further confirmations.

That's how I follow all my lists, reading and replying to them as 
newsgroups via the gmane list2news interface.

http://gmane.org for more info.

The one caveat is that while on a lot of lists replies to the list only 
is the norm, on the Linux kernel and vger.kernel.org hosted lists 
(including this one), replying to all, list and previous posters, is the 
norm, and I'm not sure if the web interface allows that.  On the news 
interface it of course depends on your news client -- mine is more 
adapted to news than mail, and while it allows forwarding to your normal 
mail client for the mail side, normal followups are to news only, and 
it's not easy to reply to all, so I generally reply to list (as 
newsgroup) only, unless a poster specifically requests to be CCed on 
replies.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

