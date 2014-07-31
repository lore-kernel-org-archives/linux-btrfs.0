Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58054 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaGaFyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 01:54:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XCjJT-0007BK-PQ
	for linux-btrfs@vger.kernel.org; Thu, 31 Jul 2014 07:54:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 07:54:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 07:54:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
Date: Thu, 31 Jul 2014 05:53:51 +0000 (UTC)
Message-ID: <pan$2dd8b$8ee08dd2$83d9cc3a$b36b9501@cox.net>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
	<CAPM=9ty2PhMdLykVX4c074Tdkyh0OO_jtfw-CAFHk8ANcZA4kQ@mail.gmail.com>
	<CAPDOMVgXChx5HST-jMEZmWDydWKe0Yv15pyTiPeOuQSVEjihFA@mail.gmail.com>
	<CAPM=9txGAA3sanpjYBgAuk0BynZRP56SRBfL_Rd88oDzBKHZ_g@mail.gmail.com>
	<CAPDOMVgM+E1XxsFvhAYWzHo7HCFqp6sO6Y53_m2am-fno6m_AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nick Krause posted on Thu, 31 Jul 2014 00:14:50 -0400 as excerpted:

>  I am wondering if some one can
> give me a pointer on where to download the git repos for the btrfs user
> spaces tools as it seems on the btrfs tools on the wiki.

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#btrfs-progs_git_repository

You mean the URLs listed there?  The official repo listed there is the same one
found in the gentoo btrfs-progs live-ebuild, for those (like me) that prefer
that to the versioned ebuild.  I've no reason to believe that the integration
-branch URLs listed there are invalid, either, tho I've personally stuck to the
offical repo, master branch, which as of the last time I did an update was still
at v3.14.2, tho I've seen enough patches on the list I'm expecting a v3.16
release shortly after the v3.16 kernel release.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

