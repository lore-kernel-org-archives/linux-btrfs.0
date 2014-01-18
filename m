Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:38050 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbaARBJt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 20:09:49 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob11.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0I19l5u000514
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 20:09:47 -0500
Message-ID: <52D9D479.5040809@chinilu.com>
Date: Fri, 17 Jan 2014 17:10:17 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
In-Reply-To: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/17/2014 04:23 PM, Ian Hinder wrote:
> Hi,
>
> I have been reading a lot of articles online about the dangers of using ZFS with non-ECC RAM.  Specifically, the fact that when good data is read from disk and compared with its checksum, a RAM error can cause the read data to be incorrect, causing a checksum failure, and the bad data might now be written back to the disk in an attempt to correct it, corrupting it in the process.  This would be exacerbated by a scrub, which could run through all your data and potentially corrupt it.  There is a strong current of opinion that using ZFS without ECC RAM is "suicide for your data".
>
> I have been unable to find any discussion of the extent to which this is true for btrfs.  Does btrfs handle checksum errors in the same way as ZFS, or does it perform additional checks before writing "corrected" data back to disk?  For example, if it detects a checksum error, it could read the data again to a different memory location to determine if the error existed in the disk copy or the memory.
>
> >From what I've been reading, it sounds like ZFS should not be used with non-ECC RAM.  This is reasonable, as ZFS' resource requirements mean that you probably only want to run it on server-grade hardware anyway.  But with btrfs eventually being the default filesystem for Linux, that would mean that all linux machines, even cheap consumer-grade hardware, would need ECC RAM, or forego many of the advantages of btrfs.
>
> What is the situation?
>
This subject is already being discussed on this list under the title of 
"drawbacks of non-ECC RAM".  So I suggest you follow that thread back 
and THEN come back with any further questions.
