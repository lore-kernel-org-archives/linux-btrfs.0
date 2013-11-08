Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:21994 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757582Ab3KHToD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 14:44:03 -0500
Received: from [66.162.154.131] (port=51948 helo=[10.1.8.1])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VeryK-001RfG-O0
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 12:44:01 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Question about btrfs as root filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <527D267D.9010403@inwind.it>
Date: Fri, 8 Nov 2013 12:43:59 -0700
Message-Id: <AF9AF4F3-B21D-404F-91C9-59CB15080DEB@colorremedies.com>
References: <29341211.3154771383915306434.JavaMail.defaultUser@defaultHost> <8B95F9DF-83EC-4F49-8E5E-B5052FB778F9@colorremedies.com> <527D267D.9010403@inwind.it>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 8, 2013, at 10:59 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
>> 
>> Now I don't know what snapshot that is, since it's just renamed to
>> some non-descriptive name like "root" which happens to, by
>> convention, always be the active root. This is the problem with using
>> user domain to store contextual metadata. We need another way to do
>> this, rather than inject these changes into filename/foldername which
>> are primarily user domain. And we need agreement on a right way to do
>> this rather than distribution convention.
> 
> Put all the required information in an xattr...
> 
>> 
>> We need some distribution collaboration in this area, or this is
>> going to turn into an end-user pain point, with multiboot users top
>> on the list of the injured.
> 
> I fully agree: whatever solution we found, it has to be shared across
> all distributions.

Yes although not merely shared. But designed and agreement by. Otherwise this becomes worse than the linux multiboot situation, which today is pretty much a broken mess in which linux distributions break the bootability of the existing linux OS installation, and do so by default. It's an ironic case where a linux distro is friendly to co-existing with Windows and OS X, but typically is downright hostile to fellow linux OS installations.

Now if we want to admit that the different distros are in effect all hostile competitor OS's to each other, then I guess a free for all where an open filesystem like Btrfs effectively becomes proprietary due to highly complex and variable layouts required to support snapshot system rollbacks is what we'll just have to expect. In which case multiboot on Btrfs is dead in the water. Each distro would have to have their own volume, not their own subvolumes.

Chris Murphy