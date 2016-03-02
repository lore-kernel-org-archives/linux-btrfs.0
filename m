Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35295 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbcCBNn2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 08:43:28 -0500
Received: by mail-qg0-f43.google.com with SMTP id y89so168923490qge.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Mar 2016 05:43:28 -0800 (PST)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id d71sm14892458qhd.18.2016.03.02.05.43.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 02 Mar 2016 05:43:26 -0800 (PST)
Subject: Re: raid5
To: linux-btrfs@vger.kernel.org
References: <CAAcrkYL_=8Ru+_Aum_ZR14AD-D44Dki7Qr9pyAzezWMMZJ8A2w@mail.gmail.com>
 <pan$d7909$c07dac53$17a8f04a$fdf6e07b@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D6EDF5.2010408@gmail.com>
Date: Wed, 2 Mar 2016 08:43:17 -0500
MIME-Version: 1.0
In-Reply-To: <pan$d7909$c07dac53$17a8f04a$fdf6e07b@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-01 16:44, Duncan wrote:
> John Smith posted on Tue, 01 Mar 2016 15:24:04 +0100 as excerpted:
>
>> what is the status of  btrfs raid5 in kernel 4.4? Thank you
>
> That is a very good question. =:^)
>
> The answer, to the best I can give it, is, btrfs raid56 mode has no known
> outstanding bugs specific to it at this time (unless a dev knows of any,
> but I've not seen any confirmed on-list), and hasn't had any, at least
> nothing major, since early in the 4.1 cycle, so 4.2 thru 4.4 should be
> clean of /known/ raid56 bugs.
That really depends on what you consider to be a bug...

For example, for most production usage, the insanely long 
rebuild/rebalance times that people are seeing with BTRFS raid56 (on the 
order of multiple days per terabyte of data to be rebuilt, compared to a 
couple of hours for a rebuild on the same hardware using MDRAID or LVM) 
would very much be considered a serious bug, as it significantly 
increases the chances of data loss due to further disk failures. 
Personally, my recommendation would be to not use BTRFS raid56 for 
anything other than testing if you're working with data-sets bigger than 
about 250G until this particular issue gets fixed, which may be a while 
as we can't seem to figure out what exactly is causing the problem.

