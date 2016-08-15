Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37625 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbcHONsD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 09:48:03 -0400
Received: by mail-it0-f41.google.com with SMTP id f6so42738240ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 06:47:58 -0700 (PDT)
Subject: Re: How to stress test raid6 on 122 disk array
To: Martin <rc6encrypted@gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com>
 <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
 <CAGQ70YfvcujVWs-Hr-jLS5DED3ti5XK=fVhx6M8K7c85UVYDhA@mail.gmail.com>
 <m49k2fvmsi2.fsf@coffee.modeemi.fi>
 <CAGQ70Ycengg60hu3Wm5BxVHxUwhdfydmKFEy55RG8WnDZrgqqA@mail.gmail.com>
 <65cdf178-4992-2061-5b04-7072041ce924@gmail.com>
 <CAGQ70Ydg9U0QH57tuWfctnFYQRx9LW6VROnd-+VGfnxmjHTYEg@mail.gmail.com>
Cc: Erkki Seppala <flux-btrfs@inside.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <da9e55fc-f5d9-0173-0a8b-33d33fcc8cf0@gmail.com>
Date: Mon, 15 Aug 2016 09:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAGQ70Ydg9U0QH57tuWfctnFYQRx9LW6VROnd-+VGfnxmjHTYEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 09:39, Martin wrote:
>> That really is the case, there's currently no way to do this with BTRFS.
>> You have to keep in mind that the raid5/6 code only went into the mainline
>> kernel a few versions ago, and it's still pretty immature as far as kernel
>> code goes.  I don't know when (if ever) such a feature might get put in, but
>> it's definitely something to add to the list of things that would be nice to
>> have.
>>
>> For the moment, the only option to achieve something like this is to set up
>> a bunch of separate 8 device filesystems, but I would be willing to bet that
>> the way you have it configured right now is closer to what most people would
>> be doing in a regular deployment, and therefore is probably more valuable
>> for testing.
>>
>
> I see.
>
> Right now on our +500TB zfs filesystems we used raid6 with a 6 disk
> vdev, which is often in the zfs world, and for btrfs I would be the
> same when stable/possible.
>
A while back there was talk of implementing a system where you could 
specify any arbitrary number of replicas, stripes or parity (for 
example, if you had 16 devices, you could tell it to do two copies with 
double parity using full width stripes), and in theory, it would be 
possible there (parity level of 2 with a stripe width of 6 or 8 
depending on how it's implemented), but I don't think it's likely that 
that functionality will exist any time soon.  Implementing such a system 
would pretty much require re-writing most of the allocation code (which 
probably would be a good idea for other reasons now too), and that's not 
likely to happen given the amount of coding that went into the raid5/6 
support.
