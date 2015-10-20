Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33138 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbbJTTwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 15:52:47 -0400
Received: by wijp11 with SMTP id p11so63800663wij.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 12:52:46 -0700 (PDT)
Received: from [10.0.2.15] (p508DE351.dip0.t-ipconnect.de. [80.141.227.81])
        by smtp.googlemail.com with ESMTPSA id p7sm5756006wjf.26.2015.10.20.12.52.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2015 12:52:45 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: Re: How to remove missing device on RAID1?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
Message-ID: <56269B8E.7090108@googlemail.com>
Date: Tue, 20 Oct 2015 21:52:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kyle,

On 10/20/2015 07:24 PM, Kyle Manna wrote:
> I removed the device from the system, rebooted and mounted the volume
> with `-o degraded` and the file system seems fine and usable.  I'm
> waiting on a replacement, drive but want to remove the old drive and
> re-balance in the meantime.

This won't answer your question (not sure why missing doesn't work 
anymore), but you could wait for the replacement and then run "btrfs 
replace start 1 /dev/sdd /mnt", where 1 is the devid of the missing 
drive (dmesg will tell you) and /dev/sdd is the new drive. This way, the 
drive will keep its devid, which may be useful if the ids are used to 
identify the drives (mirror will still have id 1 as first drive and id 2 
as second drive as opposed to 2 = first and 3 = second).



Philip
