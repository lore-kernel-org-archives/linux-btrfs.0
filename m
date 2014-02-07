Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52451 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751620AbaBGSo6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 13:44:58 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Provide a better free space estimate on RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140207120812.43dc7982@natsu>
Date: Fri, 7 Feb 2014 11:44:54 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <A9FC77DF-E4FC-4E60-94C9-CE8927FB1B9F@colorremedies.com>
References: <20140206021516.304732cd@natsu> <52F33BE7.4020708@swiftspirit.co.za> <20140206184502.128b7dbe@natsu> <52F3E86B.4030805@libero.it> <20140207104005.7bd1438a@natsu> <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com> <20140207120812.43dc7982@natsu>
To: Roman Mamedov <rm@romanrm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 6, 2014, at 11:08 PM, Roman Mamedov <rm@romanrm.net> wrote:

>  And what
> if I am accessing that partition on a server via a network CIFS/NFS share and
> don't even *have a way to find out* any of that.

That's the strongest argument. And if the user is using Explorer/Finder/Nautilus to copy files to the share, I'm pretty sure all three determine if there's enough free space in advance of starting the copy. So if it thinks there's free space, it will start to copy and then later fail midstream when there's no more space. And then the user's copy task is in a questionable state as to what's been copied, depending on how the file copies are being threaded.

And due to Btrfs metadata requirements even when deleting, we actually need an Avail estimate that accounts for "phantom future metadata" as if it's currently in use, otherwise we don't really have the right indication of whether or not files can be copied. 


Chris Murphy