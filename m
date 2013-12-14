Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:36501 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3LNJ6l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 04:58:41 -0500
Received: by mail-qc0-f179.google.com with SMTP id i8so2339181qcq.10
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 01:58:41 -0800 (PST)
Received: from [192.168.18.6] (cpe-174-106-200-117.ec.res.rr.com. [174.106.200.117])
        by mx.google.com with ESMTPSA id lc1sm16053388qeb.5.2013.12.14.01.58.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 14 Dec 2013 01:58:39 -0800 (PST)
Message-ID: <52AC2B90.909@czarc.net>
Date: Sat, 14 Dec 2013 04:57:36 -0500
From: Gene Czarcinski <gczarcinski@gmail.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: moving a subvol
References: <52AB30D4.7050408@czarc.net> <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com> <52AB5F2E.8020209@czarc.net> <1663965.RJ0nqNbRyM@quad>
In-Reply-To: <1663965.RJ0nqNbRyM@quad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2013 02:07 AM, Chris Samuel wrote:
> On Fri, 13 Dec 2013 02:25:34 PM Gene Czarcinski wrote:
>
>> Next it is to delete the old BTRFS volume, use fdisk to increase the
>> size of the partition and then attempt to increate the size of this new
>> volume.  I hope I don't get bit in the rear end with this.
>
> Just make sure you have good (tested) backups..
>
Data subvolumes such as for /home have separate backups but the rootfs 
subvolumes do not.  If somethings gets screwed up, it is a matter of 
reinstalling.  Since I run Fedora with anaconda I use kickstart installs 
and can easily repeat an install since it included almost everything I 
want installed.  And then I have a post-install script I run to pickup 
additional stuff.

After successfully resizing, I then repeated with a two-device BTRFS 
volume.  Here the resize needs to be done for each device.

Question:  What is did involved two BTRFS volumes on /dev/sdb1 and 
/dev/sdb2.  I deleted /dev/sdb2 and then expanded/resized /dev/sdb1. 
This worked but I assume that doing the opposite would not work.  That 
is, deleteing the "lower" /dev/sdb1 and then expanding the "upper" 
/dev/sdb2 because after rebooting the filesystem would not be at the 
beginning of the partition.

Gene
