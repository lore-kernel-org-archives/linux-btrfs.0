Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44692 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3K0CuJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 21:50:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAGKKSfV_OQKy3_5HmiMUxV=HFE9OpAVsnyzV_WTh14smMdm7Wg@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<CAGKKSfUGLzeLfab0uJTGV=UELxEH+mB3K4VbDouHxzmc+xuZ2A@mail.gmail.com>
	<528D0913.1070604@zytor.com>
	<BD8F4758-37F1-44FC-8FB6-0F798FE626DF@cs.utk.edu>
	<CAGKKSfV_OQKy3_5HmiMUxV=HFE9OpAVsnyzV_WTh14smMdm7Wg@mail.gmail.com>
Date: Tue, 26 Nov 2013 18:50:08 -0800
Message-ID: <CAN05THSY7v2=S=vdAj8Mw_uXX=XKU2Fsi-YSMjBrjb-U0=_CLw@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is great stuff.
Now, how can we get this into btrfs and md?


On Wed, Nov 20, 2013 at 1:23 PM, Andrea Mazzoleni <amadvance@gmail.com> wrote:
> Hi,
>
>> First, create a 3 by 6 cauchy matrix, using x_i = 2^-i, and y_i = 0 for i=0, and y_i = 2^i for other i.
>> In this case:   x = { 1, 142, 71, 173, 216, 108 }  y = { 0, 2, 4).  The cauchy matrix is:
>>
>>   1   2   4   8  16  32
>> 244  83  78 183 118  47
>> 167  39 213  59 153  82
>>
>> Divide row 2 by 244 and row 3 by 167.  Then extend it with a row of ones on top and it's still MDS,
>> and  that's the code for m=4, with RAID-6 as a subset.  Very nice!
>
> You got it Jim!
>
> Thanks,
> Andrea
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
