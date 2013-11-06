Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49870 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab3KFMUU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 07:20:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ve25p-0006FG-7T
	for linux-btrfs@vger.kernel.org; Wed, 06 Nov 2013 13:20:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 13:20:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 13:20:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: csum failure messages
Date: Wed, 6 Nov 2013 12:19:54 +0000 (UTC)
Message-ID: <pan$a6cc3$5081ede9$fee68bf7$e93d0c29@cox.net>
References: <201311051224.44255.russell@coker.com.au>
	<CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
	<201311052316.34979.russell@coker.com.au>
	<49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
	<20131105143438.GM14405@carfax.org.uk>
	<CAJBj3veWmB4m+pR2SdZ=y4pRVXfR5aGpfjH2HhoFXbARcZy34w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams posted on Tue, 05 Nov 2013 16:20:58 -0800 as excerpted:

> Is there now a verification test that could detect an issue like this?
> It seems like the sort of thing that needs to be added to automated
> testing.

[Your question is general enough, not mentioning xfs-tests, simply asking 
about general automated testing, I'm assuming a general answer is 
appropriate.]

I haven't tracked this specific issue, but in general, the btrfs devs are 
pretty strict with adding an xfs-tests (NOT used for just xfs, at least 
btrfs and ext4 use it too) package test for any regressions they find, 
and people ARE regularly running those tests on new code, so past issues 
don't happen again.  

If you watch the list you'll see occasional patch rejections due to 
failed xfs-tests, as well as regular new xfs-tests patches adding new 
tests, as well as review discussion requesting an xfs-test be added as 
appropriate.

So I'd be /very/ surprised if this bugfix didn't already have a 
corresponding new xfs-tests test.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

