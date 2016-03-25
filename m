Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58594 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbcCYB7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 21:59:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajH27-0001MS-Po
	for linux-btrfs@vger.kernel.org; Fri, 25 Mar 2016 02:59:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 02:59:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 02:59:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: mkfs: allow DUP on multidev fs, only warn
Date: Fri, 25 Mar 2016 01:59:20 +0000 (UTC)
Message-ID: <pan$83413$34f18f9e$a1606444$9239e69f@cox.net>
References: <1458834973-3199-1-git-send-email-dsterba@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba posted on Thu, 24 Mar 2016 16:56:13 +0100 as excerpted:

> The DUP profile can work on multiple filesystems, the limitation is
> rather artificial. Let the user make the decision and print a warning.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---

I like the change, but typo in the commit comment... What filesystems 
other than btrfs allow DUP? =:^)  It's correct in the posting subject.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

