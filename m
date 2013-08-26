Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62156 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3HZR0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 13:26:42 -0400
Received: by mail-qa0-f46.google.com with SMTP id i13so667423qae.12
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 10:26:41 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Nicholas Lee <email@nickle.es>
In-Reply-To: <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es>
Date: Mon, 26 Aug 2013 13:26:40 -0400
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com> <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good news everyone! I got this to mount again using btrfs chunk-recover on the partition! It took around a day for it to run the initial chunk recovery scan (iotop showed that I was limited by disk throughput) and another three hours for the actual chunk recovery (iops limited).

Hopefully someone out there that runs into a similar issue will end up finding this!

On 22.08.2013, at 21:36, Nicholas Lee <email@nickle.es> wrote:

> 6. I don't know off the top of my head, but I'd assume it was the default. It was created by Ubuntu Server Edition
> 7.  I installed btrfs-progs-git from the AUR, and it (pretty much instantly) returns the following error: 
> 
> sudo btrfsck /dev/main-storage-vg/root 
> Couldn't map the block 1781900460032
> btrfsck: volumes.c:1020: btrfs_num_copies: Assertion `!(ce->start > logical || ce->start + ce->size < logical)' failed.
> 
> If chunk-recover finds anything, I'll let you guys know. (It's still running, and I have yet to write anything.)
> 
> 
> On 22.08.2013, at 20:58, Chris Murphy <lists@colorremedies.com> wrote:
>> 
>> 6. What was the mkfs.btrfs command used? In particular are you certain the metadata profile is default (DUP)?
>> 
>> 7. If you have a very recent btrfs-progs (few months at most), or better if you can build from btrfs-next, it may be worth running btrfsck *without* the repair option, to see what it has to say about the situation.
> 

