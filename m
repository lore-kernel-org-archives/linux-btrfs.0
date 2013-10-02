Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:30867 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751518Ab3JBAmf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 20:42:35 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131001234655.GA7937@pyropus.ca>
Date: Tue, 1 Oct 2013 18:42:31 -0600
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Message-Id: <441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com>
References: <20131001211255.GA5946@pyropus.ca> <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com> <20131001234655.GA7937@pyropus.ca>
To: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 1, 2013, at 5:46 PM, Charles Cazabon <charlesc-lists-btrfs@pyropus.ca> wrote:
> 
>  # btrfs fi df /media/bigbackup/
>  Data: total=4.53TB, used=4.22TB
>  System, DUP: total=8.00MB, used=508.00KB
>  System: total=4.00MB, used=0.00
>  Metadata, DUP: total=18.00GB, used=17.13GB
>  Metadata: total=8.00MB, used=0.00

Since there's only one copy of the data, there isn't a way to repair it, it just notes that there is a checksum mismatch.
> 
>> btrfs show
> 
> This fails with `btrfs: unknown token 'show'`.

I meant 'btrfs fi show'


> As I say, it's 8 disks (yes, SATA).  What info exactly do you want about the
> disks and ports? 

Looking for problems that relate to this one.

When was the last time you did a scrub on the md device? And what was the result?

What is the 'smartctl -l scterc /dev/sdX' result for one of the drives?

This sounds to me like it could be a bit flip, and btrfs is catching it but doesn't have a 2nd copy of the data. Just a guess.

Chris Murphy