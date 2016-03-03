Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42307 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcCCKRx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 05:17:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abQKL-0000P3-W9
	for linux-btrfs@vger.kernel.org; Thu, 03 Mar 2016 11:17:50 +0100
Received: from 66-87-139-73.pools.spcsdns.net ([66-87-139-73.pools.spcsdns.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 11:17:49 +0100
Received: from eternaleye by 66-87-139-73.pools.spcsdns.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 11:17:49 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC] Experimental btrfs encryption
Date: Thu, 3 Mar 2016 10:17:39 +0000 (UTC)
Message-ID: <loom.20160303T111025-895@post.gmane.org>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com> <56D63CB1.5070202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo <at> cn.fujitsu.com> writes:
<snip>
> > - As of now uses "user" keytype, I am still considering/
> >    evaluating other key type such as logon.
> 
> UI things can always be reconsidered later.
> Never a big problem.

This is not only a UI concern, but an API/ABI concern.

To use eCryptFS as an example, on mount(2) you pass the information for it
to look up the key in the kernel keyring, and it looks for a key of type
"user" - I have personally written code that uses trusted and encrypted
keys, and the raw mount(2) call (sans any of the eCryptFS userspace
libraries) to mount eCryptFS filesystems sealed to the TPM.

If eCryptFS switched to using another key type, my code would cease to work
unless the filesystem jumped through hoops to do so in a
backwards-compatible way. Similarly, while eCryptFS uses a "user" key, it
requires that key have a specific structure - as a result, the encrypted
keys support added a key type of "ecryptfs" to create random keys with the
appropriate structure, meaning the key type for unencrypted keys and the
encrypted key key type field differ. This is surprising and non-obvious, and
took some time to figure out in my implementation.

The way btrfs encryption interacts with the keyring APIs is important, and
"reconsidering later" will potentially represent an API/ABI break. Please
keep it in mind.

