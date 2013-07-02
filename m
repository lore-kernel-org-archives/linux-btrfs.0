Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eta.wiserhosting.co.uk ([85.92.82.55]:46436 "EHLO
	eta.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3GBRfu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 13:35:50 -0400
Message-ID: <51D30FB0.5000304@petezilla.co.uk>
Date: Tue, 02 Jul 2013 18:36:48 +0100
From: Peter Chant <pete@petezilla.co.uk>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Hardware failure or btrfs issue?
References: <51D2091E.9010800@petezilla.co.uk> <20130702072915.GA8170@carfax.org.uk>
In-Reply-To: <20130702072915.GA8170@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2013 08:29 AM, Hugo Mills wrote:
> This is usually an indication that you have bad hardware -- I'd 
> suggest testing RAM, PSU, CPU in that order. I'm not sure what, if 
> anything, can be done to fix the error on the disk right now. 

Thanks, appreciated.

Hmm.  I've got one stick of ram out of the machine due to testing as I 
had some freezes last week.
If it were one of the RAM, PSU and CPU then I'm unsure why this IO issue 
only surfaces on the HDD and not the SSD.  I ordered a new HDD last 
night, before reading your post.  If its not the disk I'll go raid1.  If 
it is the disk then I'll probally find out.

>> Not that I've done anything other than a cursory check but it looks
>> like the read only data is fine.
>     Might be a good idea to use that to refresh your backups, just in
> case my prediction about the fixability is correct.

Well, first option is to drop in the new disk, freshly format it and 
copy the data across (not add it as a second disk).  If that fails last 
backup was wednesday.  I've not done much of note since then apart from 
try to fix the disk issues.


