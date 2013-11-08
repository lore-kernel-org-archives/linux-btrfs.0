Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49429 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757362Ab3KHRo5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 12:44:57 -0500
Received: from 105-34-agavebb-nm.abq.nm.agavebb.net ([199.21.105.34]:57967 helo=[10.1.8.1])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Veq76-000XG6-5u
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 10:44:56 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Question about btrfs as root filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <29341211.3154771383915306434.JavaMail.defaultUser@defaultHost>
Date: Fri, 8 Nov 2013 10:44:55 -0700
Message-Id: <8B95F9DF-83EC-4F49-8E5E-B5052FB778F9@colorremedies.com>
References: <29341211.3154771383915306434.JavaMail.defaultUser@defaultHost>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 8, 2013, at 5:55 AM, Goffredo Baroncelli <kreijack@libero.it> <kreijack@libero.it> wrote:
> 
> Instead of using set-default, I am used to rename the subvolume.
> I.E. I assume that the root filesystem is a subvolume always called 
> "__active". 
> When I want to rollback, I rename "__active" in "__broken" (or 
> remove it), then I rename (or re-snapshot) "snapshot-yyyymmdd" 
> in "__active".
> 
>>> That way, we ensure the best compatibility and lowest maintenance, 
>> as we don't overwrite default init functions.
>> 
>> I'm sympathetic to the alternative problem, which is that you need to 
>> alter grub.cfg to use the proper rootflags=subvol= to explicitly use the 
>> proper snapshot, and also it would mean altering the /etc/fstab within 
>> that snapshot.
> 
> With rename you can address both the issues

Now I don't know what snapshot that is, since it's just renamed to some non-descriptive name like "root" which happens to, by convention, always be the active root. This is the problem with using user domain to store contextual metadata. We need another way to do this, rather than inject these changes into filename/foldername which are primarily user domain. And we need agreement on a right way to do this rather than distribution convention. 

We need some distribution collaboration in this area, or this is going to turn into an end-user pain point, with multiboot users top on the list of the injured.


Chris Murphy