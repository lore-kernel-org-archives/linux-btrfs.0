Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57298 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaIAQgv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 12:36:51 -0400
Received: by mail-lb0-f182.google.com with SMTP id u10so6275785lbd.27
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Sep 2014 09:36:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <540498AF.6030109@fb.com>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
Date: Mon, 1 Sep 2014 18:36:49 +0200
Message-ID: <CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: john terragon <jterragon@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was trying it again and it seems to have completed, albeit very
slowly (even for an usb flash drive). Was the 3.14 series the last
immune one from this problem? Should I try the latest 3.14.x?

Thanks
John

On Mon, Sep 1, 2014 at 6:02 PM, Chris Mason <clm@fb.com> wrote:
> On 09/01/2014 09:33 AM, john terragon wrote:
>> Hi.
>>
>> I'm not sure if this is related to the hung task problem that I've
>> been seeing in this ml for a while. But  I've been having this
>> seemingly related problem with 3.15, 3.16 and now 3.17-rc3 (which, if
>> I'm not mistaken, should have a fix for the hung task problem). So
>> here it is: I have a usb flash drive with btrfs (on top of dmcrypt)
>> usually mounted with these options
>>
>> rw,noatime,compress-force=zlib,ssd,space_cache,autodefrag
>>
>> When I try to rsync the usb flash drive I get a truck-load of "INFO:
>> task rsync:2524 blocked for more than 120 seconds" as you can see
>> below.
>> The rsync process crawls into an almost complete stop and I can't even
>> kill it. I know the usb key is OK because I've tried the same thing
>> with ext4 and xfs and everything went fine.
>
> This does have all of our fixes for hangs.  Does the rsync eventually
> complete?  Or do we just sit there forever?
>
> -chris
