Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:35786 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbG1XXy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 19:23:54 -0400
Received: by vnaa140 with SMTP id a140so48844029vna.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 16:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+zbGr_adypZYbm7xcu1PZnLvuh1Nkba2VL-d-G2vFOde2hBQw@mail.gmail.com>
References: <CA+zbGr_adypZYbm7xcu1PZnLvuh1Nkba2VL-d-G2vFOde2hBQw@mail.gmail.com>
Date: Tue, 28 Jul 2015 17:23:53 -0600
Message-ID: <CAJCQCtQ8N=cNk+aCEPLc0ffYf7JK9p=4GzvKvupWLZHczP0vfw@mail.gmail.com>
Subject: Re: Error removing an HDD from a RAID1 BTRFS array
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 4:09 PM, Alejandro Recarey <alex@recarey.org> wrote:

>   > # ./btrfs device delete /dev/sda /storage
>   ERROR: error removing the device '/dev/sda' - No space left on device

>> # uname -a
> Linux nerd-server 3.13.0-48-generic \

I can't even begin to tell you how much has changed since this kernel
version, it's also EOL. I suggest 4.1.3 and see if you can delete this
device, because obviously the error is bogus. There's lots of
unallocated space on all drives, including sda, so a no space left on
device is simply wrong.


-- 
Chris Murphy
