Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:53566 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab3KHR7b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 12:59:31 -0500
Message-ID: <527D267D.9010403@inwind.it>
Date: Fri, 08 Nov 2013 18:59:25 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question about btrfs as root filesystem
References: <29341211.3154771383915306434.JavaMail.defaultUser@defaultHost> <8B95F9DF-83EC-4F49-8E5E-B5052FB778F9@colorremedies.com>
In-Reply-To: <8B95F9DF-83EC-4F49-8E5E-B5052FB778F9@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-08 18:44, Chris Murphy wrote:
> 
> On Nov 8, 2013, at 5:55 AM, Goffredo Baroncelli <kreijack@libero.it>
> <kreijack@libero.it> wrote:
>> 
>> Instead of using set-default, I am used to rename the subvolume. 
>> I.E. I assume that the root filesystem is a subvolume always called
>>  "__active". When I want to rollback, I rename "__active" in
>> "__broken" (or remove it), then I rename (or re-snapshot)
>> "snapshot-yyyymmdd" in "__active".
>> 
>>>> That way, we ensure the best compatibility and lowest
>>>> maintenance,
>>> as we don't overwrite default init functions.
>>> 
>>> I'm sympathetic to the alternative problem, which is that you
>>> need to alter grub.cfg to use the proper rootflags=subvol= to
>>> explicitly use the proper snapshot, and also it would mean
>>> altering the /etc/fstab within that snapshot.
>> 
>> With rename you can address both the issues
> 
> Now I don't know what snapshot that is, since it's just renamed to
> some non-descriptive name like "root" which happens to, by
> convention, always be the active root. This is the problem with using
> user domain to store contextual metadata. We need another way to do
> this, rather than inject these changes into filename/foldername which
> are primarily user domain. And we need agreement on a right way to do
> this rather than distribution convention.

Put all the required information in an xattr...

> 
> We need some distribution collaboration in this area, or this is
> going to turn into an end-user pain point, with multiboot users top
> on the list of the injured.

I fully agree: whatever solution we found, it has to be shared across
all distributions.
> 
> 
> Chris Murphy-- To unsubscribe from this list: send the line
> "unsubscribe linux-btrfs" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
