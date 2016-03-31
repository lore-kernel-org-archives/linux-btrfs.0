Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60187 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949AbcCaVIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aljpD-0001gT-6Z
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 23:08:19 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 23:08:19 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 23:08:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] Btrfs: fix file/data loss caused by fsync after
 rename and new inode
Date: Thu, 31 Mar 2016 21:08:12 +0000 (UTC)
Message-ID: <pan$5850$b3903f86$45916929$4ad78c4d@cox.net>
References: <1459330710-3181-1-git-send-email-fdmanana@kernel.org>
	<1459377441-3609-1-git-send-email-fdmanana@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fdmanana posted on Wed, 30 Mar 2016 23:37:21 +0100 as excerpted:

> From: Filipe Manana <fdmanana@suse.com>
> 
> If we rename an inode A (be it a file or a directory), create a new
> inode B with the old name of inode A and under the same parent
> directory, fsync inode B and then power fail, at log tree replay time
> we end up removing inode A completely. If inode A is a directory then
> all its files are gone too.

...

> V2: Node code changes, only updated the change log and the comment to
>     be more clear about the problems solved by the new checks.

If there's a V3 anyway, apparent typo:

s/Node code/No code/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

