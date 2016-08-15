Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35288 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbcHONjB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 09:39:01 -0400
Received: by mail-qk0-f175.google.com with SMTP id v123so42478890qkh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 06:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <65cdf178-4992-2061-5b04-7072041ce924@gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com> <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
 <CAGQ70YfvcujVWs-Hr-jLS5DED3ti5XK=fVhx6M8K7c85UVYDhA@mail.gmail.com>
 <m49k2fvmsi2.fsf@coffee.modeemi.fi> <CAGQ70Ycengg60hu3Wm5BxVHxUwhdfydmKFEy55RG8WnDZrgqqA@mail.gmail.com>
 <65cdf178-4992-2061-5b04-7072041ce924@gmail.com>
From: Martin <rc6encrypted@gmail.com>
Date: Mon, 15 Aug 2016 15:39:00 +0200
Message-ID: <CAGQ70Ydg9U0QH57tuWfctnFYQRx9LW6VROnd-+VGfnxmjHTYEg@mail.gmail.com>
Subject: Re: How to stress test raid6 on 122 disk array
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Erkki Seppala <flux-btrfs@inside.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> That really is the case, there's currently no way to do this with BTRFS.
> You have to keep in mind that the raid5/6 code only went into the mainline
> kernel a few versions ago, and it's still pretty immature as far as kernel
> code goes.  I don't know when (if ever) such a feature might get put in, but
> it's definitely something to add to the list of things that would be nice to
> have.
>
> For the moment, the only option to achieve something like this is to set up
> a bunch of separate 8 device filesystems, but I would be willing to bet that
> the way you have it configured right now is closer to what most people would
> be doing in a regular deployment, and therefore is probably more valuable
> for testing.
>

I see.

Right now on our +500TB zfs filesystems we used raid6 with a 6 disk
vdev, which is often in the zfs world, and for btrfs I would be the
same when stable/possible.
