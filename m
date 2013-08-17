Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:56498 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3HQMYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 08:24:49 -0400
Received: by mail-ve0-f169.google.com with SMTP id db10so2064150veb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 05:24:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130817120534.17880.11982@localhost.localdomain>
References: <CAPidFuhbjxYUqjLV_8tCCVX6aSNwZ1qJGCZvnSPx8cShGCrQvA@mail.gmail.com>
	<20130817120534.17880.11982@localhost.localdomain>
Date: Sat, 17 Aug 2013 07:24:49 -0500
Message-ID: <CAPidFuiiqWg6U5f5APH3wXibeEY7GHgT1c2_W8CH=iSydZ-JNg@mail.gmail.com>
Subject: Re: 4 vol raid5 segfault on device delete
From: Craig Johnson <crajohns@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I did this on 3.11-rc5 kernel I compiled a few days ago.
3.11.0-1-ARCH-00013-g584d88b-dirty.

Thanks!

On Sat, Aug 17, 2013 at 7:05 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Craig Johnson (2013-08-16 12:50:59)
>> I have a 4 device volume with raid5 - trying to remove one of the
>> devices (plenty of free space) and I get an almost immediate segfault.
>>  Scrub shows no errors, repair show space cache invalid but nothing
>> else (I remounted with clear cache to be safe).  Lots of corrupt on
>> bdev (for 3 out of 4 drives), but I have no file access issues that I
>> know of.  Thanks!
>>
>> Output below:
>>
>> http://pastebin.com/AnrmZrt2
>
> Hi Craig,
>
> Just double checking how you setup the device removal?  This is a 3.11
> arch kernel?  Which rc was it based from?
>
> -chris
>
