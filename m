Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47514 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbbIXFrc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 01:47:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZezNQ-00083q-6S
	for linux-btrfs@vger.kernel.org; Thu, 24 Sep 2015 07:47:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 07:47:28 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 07:47:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/4] btrfs: update qgroups in drop snapshot
Date: Thu, 24 Sep 2015 05:47:17 +0000 (UTC)
Message-ID: <pan$ee265$966e1174$56994f91$9fe0b788@cox.net>
References: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
	<20150922211251.GA17854@wotan.suse.de> <5602031A.1080905@cn.fujitsu.com>
	<20150923214926.GD17854@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Fasheh posted on Wed, 23 Sep 2015 14:49:26 -0700 as excerpted:

> On Wed, Sep 23, 2015 at 09:40:42AM +0800, Qu Wenruo wrote:
>> 
>> I'd prefer a more accurate calculation based on nodesize.
>> That would allow using any possible nodesize.
> 
> How do we query nodesize? 'btrfs fi show' doesn't seem to give it.

btrfs-show-super reports nodesize.  Note, however, that unlike
btrfs fi show, show-super is used on a device, not a (mounted) filesystem.

(A not-too-technical question I can answer, so I am. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

