Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58655 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab3IKFoa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 01:44:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VJdE5-0008Kq-HK
	for linux-btrfs@vger.kernel.org; Wed, 11 Sep 2013 07:44:29 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:44:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 07:44:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: separating data and metadata
Date: Wed, 11 Sep 2013 05:44:11 +0000 (UTC)
Message-ID: <pan$5029d$350f585e$3a74e8f7$b6768c6@cox.net>
References: <loom.20130910T193110-444@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

enzo ferrari posted on Tue, 10 Sep 2013 17:34:28 +0000 as excerpted:

> any idea about separating Btrfs' data and metadata to improve the
> security of flash storage?

I don't see that listed on the wiki features list yet, for either current 
or planned features.

Btrfs does have an ssd mode (enabled automatically in current kernels if 
non-rotating storage is detected), and a couple additional optional mount-
options (ssd-spread and discard) that could be helpful on some but not 
all SSD hardware, so those are NOT enabled by default, and btrfs does 
default to allocating separate data and metadata "chunks" on demand 
(unless the filesystem's too small, under a gig, in which case it 
defaults to "mixed"), but I don't believe it's possible to tell it to put 
data on one device and metadata on a different one, for instance.

FWIW, https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

