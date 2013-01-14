Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49586 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3ANPWk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 10:22:40 -0500
Received: by mail-lb0-f171.google.com with SMTP id gf7so2987520lbb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 07:22:39 -0800 (PST)
Message-ID: <50F422BC.4000901@gmail.com>
Date: Mon, 14 Jan 2013 15:22:36 +0000
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
References: <50F3E77B.2030901@gmail.com> <20130114145904.GA1387@shiny>
In-Reply-To: <20130114145904.GA1387@shiny>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/01/13 14:59, Chris Mason wrote:
> On Mon, Jan 14, 2013 at 04:09:47AM -0700, Tomasz Kusmierz wrote:
>> Hi,
>>
>> Since I had some free time over Christmas, I decided to conduct few
>> tests over btrFS to se how it will cope with "real life storage" for
>> normal "gray users" and I've found that filesystem will always mess up
>> your files that are larger than 10GB.
> Hi Tom,
>
> I'd like to nail down the test case a little better.
>
> 1) Create on one drive, fill with data
> 2) Add a second drive, convert to raid1
> 3) find corruptions?
>
> What happens if you start with two drives in raid1?  In other words, I'm
> trying to see if this is a problem with the conversion code.
>
> -chris
Ok, my description might be a bit enigmatic so to cut long story short 
tests are:
1) create a single drive default btrfs volume on single partition -> 
fill with test data -> scrub -> admire errors.
2) create a raid1 (-d raid1 -m raid1) volume with two partitions on 
separate disk, each same size etc. -> fill with test data -> scrub -> 
admire errors.
3) create a raid10 (-d raid10 -m raid1) volume with four partitions on 
separate disk, each same size etc. -> fill with test data -> scrub -> 
admire errors.

all disks are same age + size + model ... two different batches to avoid 
same time failure.
