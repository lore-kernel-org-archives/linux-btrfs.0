Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46514 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbbDCEhr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 00:37:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YdtMW-0007yI-6U
	for linux-btrfs@vger.kernel.org; Fri, 03 Apr 2015 06:37:44 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 06:37:44 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 06:37:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Date: Fri, 3 Apr 2015 04:37:38 +0000 (UTC)
Message-ID: <pan$47a87$b7d50fef$d2b62f95$e9e71c40@cox.net>
References: <1427336364-18161-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20150402151931.GK6821@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Thu, 02 Apr 2015 17:19:31 +0200 as excerpted:

> On Thu, Mar 26, 2015 at 10:19:24AM +0800, Qu Wenruo wrote:
>> WARNING: To ensure *btrfs-convert* be able to rollback btrfs, one
>> should never execute *btrfs filesystem defragment* or *btrfs balance*
>> command on the converted btrfs.

> I don't see now why defrag is harmful to rollback. The defragmented data
> are written to the "ext free space", ie. where all new modifications get
> written. The old data are pinned by the ext2_saved subvolume and can be
> restored. Or not?

Is defrag ever going to be snapshot-aware-enabled again?  If not, then I 
don't see that (snapshot-unaware) defrag can affect ext2_saved either.  
But with snapshot-aware-defrag, AFAIK defrag would affect ext2_saved, 
unless of course it was special-cased...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

