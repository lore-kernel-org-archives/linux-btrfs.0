Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965665Ab2JYUGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:06:43 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2258977pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 13:06:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50899A28.1050907@inwind.it>
References: <50899151.1070503@inwind.it>
	<CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
	<50899A28.1050907@inwind.it>
Date: Thu, 25 Oct 2012 14:06:42 -0600
Message-ID: <CAE5mzvhFNGaaLasFV7Vy6g7BAsTgXKpv7oo0ZVGGxCoHcmCcuA@mail.gmail.com>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: cwillu <cwillu@cwillu.com>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> Allocated_area:
>>>   Data,RAID0: Size:921.75MB, Used:256.00KB
>>>      /dev/vdc     307.25MB
>>>      /dev/vdb     307.25MB
>>>      /dev/vdd     307.25MB
>>>
>>>   Data,Single: Size:8.00MB, Used:0.00
>>>      /dev/vdb       8.00MB
>>>
>>>   System,RAID1: Size:8.00MB, Used:4.00KB
>>>      /dev/vdd       8.00MB
>>>      /dev/vdc       8.00MB
>>>
>>>   System,Single: Size:4.00MB, Used:0.00
>>>      /dev/vdb       4.00MB
>>>
>>>   Metadata,RAID1: Size:460.94MB, Used:24.00KB
>>>      /dev/vdb     460.94MB
>>>      /dev/vdd     460.94MB
>>>
>>>   Metadata,Single: Size:8.00MB, Used:0.00
>>>      /dev/vdb       8.00MB
>>>
>>>   Unused:
>>>      /dev/vdb       2.23GB
>>>      /dev/vdc       2.69GB
>>>      /dev/vdd       2.24GB
>>
>> Couple minor things, in order of personal opinion of severity:
>>
>> * Devices should be listed in a consistent order; device names are
>> just too consistently similar
> Could you elaborate ? I didn't understood well

Thereby demonstrating the problem :)

Data,RAID0: Size:921.75MB, Used:256.00KB
   /dev/vdc     307.25MB
   /dev/vdb     307.25MB
   /dev/vdd     307.25MB
Unused:
   /dev/vdb       2.23GB
   /dev/vdc       2.69GB
   /dev/vdd       2.24GB

The first goes c, b, d; the second goes b, c, d.
