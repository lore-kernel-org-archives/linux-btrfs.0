Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:34102 "EHLO
	mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaEKOI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 10:08:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 13 May 2014 10:16:59 +0200
From: laie <laie@halifax.rwth-aachen.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: destroyed disk in btrfs raid
In-Reply-To: <20140509180137.GH16185@carfax.org.uk>
References: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
 <20140509175827.GG16185@carfax.org.uk>
 <20140509180137.GH16185@carfax.org.uk>
Message-ID: <c1b636dffe4c70c4e15010000e730703@halifax.rwth-aachen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-05-09 20:01, Hugo Mills wrote:
> On Fri, May 09, 2014 at 06:58:27PM +0100, Hugo Mills wrote:
>> On Fri, May 09, 2014 at 08:02:45PM +0200, laie wrote:
>> > Now I'm looking for a way to tell btrfs to provide me with a list of the
>> > corrupted files and delete them afterwards. This would be great, because
>> > otherwise it would take very long to get the data back from slow backups.
>> 
>>    Simple solution: cat every file to /dev/null, and see which ones
>> fail with an I/O error. With RAID-0 data, losing a device is going to
>> damage most files, though, so don't necessarily expect much to 
>> survive.
> 
>    Actually, you could cat just the first 256 KiB of each file to
> /dev/null -- that should be sufficient, because with RAID-0, the
> stripe size is 64 KiB, and 256 KiB is therefore 4 stripes, and so
> should cover every device... :)

I was hoping for an internal tool, but I guess the matter is to 
specific. Thank you for the fast and easy solution.

Are you sure that using only 256KiB covers also huge files, even if only 
the last Part is missing?
