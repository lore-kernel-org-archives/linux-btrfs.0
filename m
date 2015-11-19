Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:52382 "EHLO
	gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751611AbbKSRf2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 12:35:28 -0500
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <linux-btrfs.tebulin@xoxy.net>)
	id 1ZzT7I-0003Sh-1j
	for linux-btrfs@vger.kernel.org; Thu, 19 Nov 2015 17:35:28 +0000
From: linux-btrfs.tebulin@xoxy.net
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk>
Message-ID: <564E085C.3060208@gmail.com>
Date: Thu, 19 Nov 2015 18:35:24 +0100
MIME-Version: 1.0
In-Reply-To: <20151118190857.GY24333@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Many thanks to everybody on the list for the awful a lot help I received. 
I'm impressed by the amount, quality and speed of the responses I received!
> See the FAQ[1] for how to interpret the output. ...
Very helpful, thanks. 
 
> The solution is to free up some of the data allocation, using a filtered balance.
As noted in my original post, this is already part of my "voodoo" I'm doing in these situations. 
Will newer kernel relieve me from this burden?

FYI: On executing "btrfs fi show" the first time after I deleted many snapshots and did a filtered (-dusage) balance, it reported sth. like 
	devid    1 size 119.21GiB used 117.03GiB
now (after a unfiltered balance?) it reports 
	devid    1 size 119.21GiB used 66.06GiB

I'm really confuzzled.

> [..] Ubuntu repeatedly chooses to stabilize on exactly the wrong kernel versions.
> ..
> Give http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.13-wily/ a try.
Could not agree more. Will give wily kernel a try.

> The output is really a little confusing. [..] should make the output more understandable. 
+1 
Considering that the status of a file systems should be understandable by regular users, it would be great if the btrfs tools could provide additional user hints like _"I seems your metadata space is running out of space. Please run `foo bar` to resolve this situation or consult FAQ[4] for more details"_. 

Austin Hemmelgarn commented on my ZFS comparison. His argument sound very vigilant taking into account the benefit of a  GPL-compliant FOSS FS like btrfs vs. a stabilized ZFS.

The thing I appreciate in ZFS as user most, is the very user friendly interface of it's tools. Just have a look at the following output:

	# zpool status
	Permission denied the ZFS utilities must be run as root.
	# sudo zpool status
	  pool: zfstank
	 state: ONLINE
	status: Some supported features are not enabled on the pool. The pool can
		still be used, but some features are unavailable.
	action: Enable all features using 'zpool upgrade'. Once this is done,
		the pool may no longer be accessible by software that does not support
		the features. See zpool-features(5) for details.
	  scan: scrub repaired 0 in 23h56m with 0 errors on Mon Aug 31 01:21:26 2015
	config: ...
	errors: No known data errors

This output is totally self explaining. In case of errors, ZFS will simply lists the broken files and tell you about your options to resolve the issue (restore backup, overwrite, delete). It uses easy terms & guides me in many places.

In contrast the terminology in btrfs (DUP, Metadata, Global Reserve) is rather intimidating, and as already stated, the output to a simple command like "disk free" rather difficult to understand. But btrfs seems to make progress here.

Again thanks for all the helpful feedback here on the list! 

I'm still a bit puzzled how to avoid my situation in the first place. 
Should I pick "btrfs show" in favor to "btrfs fi df" to learn about an impending "disk full" situation?  
Will newer kernels do the balance on their own? 

-Ben


