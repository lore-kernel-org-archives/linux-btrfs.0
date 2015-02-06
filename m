Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbbBFNBG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Feb 2015 08:01:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJiWv-0002hH-78
	for linux-btrfs@vger.kernel.org; Fri, 06 Feb 2015 14:01:05 +0100
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 14:01:05 +0100
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 14:01:05 +0100
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Can I get a checksum for a file from btrfs (without reading the
 whole file)?
Date: Fri, 06 Feb 2015 14:00:53 +0100
Message-ID: <mb2du5$esf$1@ger.gmane.org>
References: <mavhab$f8m$1@ger.gmane.org> <54D44F2A.8090108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <54D44F2A.8090108@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2015 06:20 AM, Qu Wenruo wrote:
> From: Lutz Vieweg <lvml@5t9.de>
>> use case: You have two huge files on a btrfs, you assume they contain the same bytes,
>> but you do not know for sure.
>>
>> Is there a way to get a checksum of both files from btrfs with less effort than
>> reading the whole of both files and computing a hash sum?
> For short, NO.
>
> For long:
> For current implement, btrfs use calculate 4K sector into 4bytes(32bit) crc32 and restore it into
> csum tree.
>
> So, for large files, e.g. 1G(already quite small for modern storage), its checksum will be 1M in size.
> Which means even using crc32 (same as kernel and crc32(a+b) = crc32(a) + crc32(b)), you still needs to
> do crc32 on the all 1M crc32.

And yet, having to read only 1 MB checksums instead of 1 GB data sounds
like a good deal - is there some userspace interface allowing to read
(only) those per-4k checksums for a file?

> But there is still some case btrfs can help you determine whether the files are the same in a faster
> way.
> Prerequisite:
> The two files are copied using clone(cp --reflink command) or deduplicated

In my case I know for sure that no cloning/deduplication happened when
the files were written.

Regards,

Lutz Vieweg

