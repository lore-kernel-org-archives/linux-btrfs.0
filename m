Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20331 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbbCaSMS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 14:12:18 -0400
Date: Tue, 31 Mar 2015 14:12:05 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
To: =?iso-8859-1?q?Torbj=F8rn?= <lists@skagestad.org>
CC: <fdmanana@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1427825525.24929.0@mail.thefacebook.com>
In-Reply-To: <55198AF9.7090403@skagestad.org>
References: <550FEC73.9010507@skagestad.org>
	<CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>
	<55100CE5.5020602@itpas.no> <1427118454.5707.5@mail.thefacebook.com>
	<55101A35.6020406@skagestad.org> <55103155.3040202@skagestad.org>
	<55198AF9.7090403@skagestad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Mon, Mar 30, 2015 at 1:42 PM, Torbjørn <lists@skagestad.org> wrote:
> Hi,
> 
> Just a follow up on this report.
> 
> The file system in question is a raid1 across 2x320G old Western 
> Digital WD3200KS.
> I janked them out of the server to run a fsck on another computer 
> (after a proper shutdown).
> 
> One of the disks did not get properly detected on the secondary 
> computer.
> Hopefully the fsck of the single disk is still of some value to you.
> 
> As you can see, there are several issues with the fs.
> The system has occasionally had hard reboots.
> 
> The fs does not have any real value for me. Everything worth anything 
> is backed up.
> I'll keep the drive around in case it's of any value for some devs.
> 
> As noted before: this (corrupted) fs only get errors when booting 
> into 4.0-rc5. With 4.0-rc4 or earlier it works as if nothing is wrong.

This is really strange because we also have reports from v3.19 stable 
kernels, but none of the btrfs patches between rc4 and rc5 were tagged 
for stable.

Can I convince you to hammer a bit more on rc4?  I'd like to make sure 
it really was a regression introdcued in rc5.

-chris



