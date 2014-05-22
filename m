Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9313 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbaEVRO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 13:14:57 -0400
Message-ID: <537E313E.8050906@fb.com>
Date: Thu, 22 May 2014 13:17:50 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com> <537D5136.4050007@suse.com> <537DEB3F.5020303@fb.com> <537E1242.1010109@suse.com>
In-Reply-To: <537E1242.1010109@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/22/2014 11:05 AM, Jeff Mahoney wrote:
> - gpg control packet
> On 5/22/14, 8:19 AM, Chris Mason wrote:
>> Can we safely reinit a kobject that has been put in use in sysfs?
>> Given all the things that can hold refs etc is this legal?
> 
> It depends on how the kobject is being used.
> 
> It wouldn't be safe to re-use the kobject embedded in space_info since
> it controls the lifetime of the object, regardless of its use in sysfs.
> 
> The kobjects for block groups only exist for creating the
> subdirectories and their lifetime is actually the lifetime of the
> space_info. We take a reference to the space_info when we add them to
> sysfs because that's where they draw their data. The only reference to
> a block group kobject is taken when we add it to sysfs and is dropped
> when we remove it. Holding a sysfs file open doesn't pin the kobject,
> so once we remove it from sysfs (kobject_del waits for readers to
> complete), it's safe to reinitialize it.
> 

Fair enough, once you've tested this new patch a bit I'll drop mine for
yours.

Thanks!

-chris

