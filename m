Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:64959 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaD1M4f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 08:56:35 -0400
Received: by mail-lb0-f170.google.com with SMTP id s7so5060541lbd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 05:56:34 -0700 (PDT)
Received: from mail-lb0-f179.google.com (mail-lb0-f179.google.com [209.85.217.179])
        by mx.google.com with ESMTPSA id q4sm18863694lbh.20.2014.04.28.05.56.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 05:56:32 -0700 (PDT)
Received: by mail-lb0-f179.google.com with SMTP id q8so4885016lbi.24
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 05:56:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A666D949-AB49-4A9B-9BD8-2D1206F5CCB0@colorremedies.com>
References: <20140426140915.GA12958@mars> <20140426143023.GK2391@carfax.org.uk>
 <20140426181827.GA14687@mars> <A666D949-AB49-4A9B-9BD8-2D1206F5CCB0@colorremedies.com>
From: Dan van der Ster <dan@vanderster.com>
Date: Mon, 28 Apr 2014 14:55:51 +0200
Message-ID: <CABZ+qqn6a40qieATtui5KqNUJMF8H3rBrpRBPCFiT_=V1thwgA@mail.gmail.com>
Subject: Re: Confusing output of btrfs fi df
To: Chris Murphy <lists@colorremedies.com>
Cc: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

On Sat, Apr 26, 2014 at 11:28 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>>
>>>   They're harmless -- it's a side-effect of the way that mkfs works.
>>> They'll go away if you balance them:
>>>
>>>   btrfs balance start -dprofiles=single -mprofiles=single -sprofiles=single /mountpoint
>>
>> btrfs refused this command, I had to pass --force to execute it.
>> It exited with this:Done, had to relocate 2 out of 2710 chunks.
>>
>> After that btrfs fi df shows the following:
>>
>> Data, RAID1: total=2.64TiB, used=2.22TiB
>> System, RAID1: total=8.00MiB, used=380.00KiB
>>> System, single: total=4.00MiB, used=0.00<
>> Metadata, RAID1: total=4.00GiB, used=2.94GiB
>
> Hmm, seems like a bug. What about

See this patch: "Btrfs: stop refusing the relocation of chunk 0"

I managed to balance away the empty single System chunk only once I
was running 3.13 from Ubuntu trusty.

http://www.spinics.net/lists/linux-btrfs/msg27119.html

https://bugzilla.kernel.org/show_bug.cgi?id=60594

Cheers, Dan
