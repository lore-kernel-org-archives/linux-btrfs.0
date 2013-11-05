Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52106 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754857Ab3KEO1H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 09:27:07 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: csum failure messages
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201311052316.34979.russell@coker.com.au>
Date: Tue, 5 Nov 2013 07:26:54 -0700
Cc: David Sterba <dsterba@suse.cz>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
References: <201311051224.44255.russell@coker.com.au> <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com> <201311052316.34979.russell@coker.com.au>
To: russell@coker.com.au
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 5, 2013, at 5:16 AM, Russell Coker <russell@coker.com.au> wrote:
> 
> I presume that my filesystem is still corrupt.

I'm the original reporter of the bug. The file system itself isn't corrupt, but the affected files probably are. In my case, systemd journal files were reported as corrupt by systemd following a balance, as well as btrfs scrub. Upon scrub, dmesg contains a path for each affected file. Upon deleting those files, subsequent scrubs come up clean.

Fedora merged the fix for this bug with: 3.11.5-302.fc20, 3.11.6-200.fc19, 3.11.6-101.fc18. I thought for sure it was marked for stable to go into mainline 3.11.6, so somehow it's been missed.

Chris Murphy