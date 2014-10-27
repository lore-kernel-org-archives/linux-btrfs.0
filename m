Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub004-omc3s28.hotmail.com ([157.55.2.37]:57103 "EHLO
	DUB004-OMC3S28.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbaJ0Qy3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 12:54:29 -0400
Message-ID: <DUB118-W2969E1F5128902D7B08B61DA9E0@phx.gbl>
From: Jasper Verberk <jverberk@hotmail.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RE: Problem converting data raid0 to raid1: enospc errors during
 balance
Date: Mon, 27 Oct 2014 16:54:27 +0000
In-Reply-To: <3E982444-5500-45BB-A04F-CF16D735CDF7@colorremedies.com>
References: <DUB406-EAS294A0E4ED8B326281AFD7C6DA9E0@phx.gbl>,<53BBD40F-B9F3-492C-9F56-15EAFC00119D@colorremedies.com>
 <DUB118-W201FD897C8121E783F626CDA9E0@phx.gbl>,<3E982444-5500-45BB-A04F-CF16D735CDF7@colorremedies.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I actually tried going to raid1 with kernel 3.10 before....the reason I updated to 3.17 was to see if this would fix the error. 

It still remained though....


----------------------------------------
> Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
> From: lists@colorremedies.com
> Date: Mon, 27 Oct 2014 10:43:41 -0600
> CC: quwenruo@cn.fujitsu.com; linux-btrfs@vger.kernel.org
> To: jverberk@hotmail.com
>
>
> On Oct 27, 2014, at 9:56 AM, Jasper Verberk <jverberk@hotmail.com> wrote:
>
>> These are the results to a normal df:
>>
>> http://paste.debian.net/128932/
>>
>> The mountpoint is /data.
>
> OK so this is with the new computation in kernel 3.17 (which I think contains a bug by counting free space twice); so now it shows available blocks based on the loss due to mirroring or parity. So 1k blocks 5860533168 = 5.45TiB. If you boot an older kernel my expectation is this shows up as 10.91TiB. In any case, df says there's 1.77TiB worth of data, so there should be plenty of space.
>
> Somewhere there's a bug. Either the 'btrfs fi df' is insufficiently communicating whether the desired operation can be done, or there's actual kernel confusion on how much space is available to do the conversion.
>
> I wonder what happens if you go back to kernel 3.16 and try do do the conversion?
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  