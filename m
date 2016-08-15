Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35483 "EHLO
	mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbcHOMTQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 08:19:16 -0400
Received: by mail-qt0-f196.google.com with SMTP id q11so2043816qtb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 05:19:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m49k2fvmsi2.fsf@coffee.modeemi.fi>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com> <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
 <CAGQ70YfvcujVWs-Hr-jLS5DED3ti5XK=fVhx6M8K7c85UVYDhA@mail.gmail.com> <m49k2fvmsi2.fsf@coffee.modeemi.fi>
From: Martin <rc6encrypted@gmail.com>
Date: Mon, 15 Aug 2016 14:19:09 +0200
Message-ID: <CAGQ70Ycengg60hu3Wm5BxVHxUwhdfydmKFEy55RG8WnDZrgqqA@mail.gmail.com>
Subject: Re: How to stress test raid6 on 122 disk array
To: Erkki Seppala <flux-btrfs@inside.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> The smallest disk of the 122 is 500GB. Is it possible to have btrfs
>> see each disk as only e.g. 10GB? That way I can corrupt and resilver
>> more disks over a month.
>
> Well, at least you can easily partition the devices for that to happen.

Can it be done with btrfs or should I do it with gdisk?

> However, I would also suggest that would it be more useful use of the
> resource to run many arrays in parallel? Ie. one 6-device raid6, one
> 20-device raid6, and then perhaps use the rest of the devices for a very
> large btrfs filesystem? Or if you have been using partitioning the large
> btrfs volume can also be composed of all the 122 devices; in fact you
> could even run multiple 122-device raid6s and use different kind of
> testing on each. For performance testing you might only excert one of
> the file systems at a time, though.

Very interesting idea, which leads me to the following question:

For the past weeks have I had all 122 disks in one raid6 filesystem,
and since I didn't entered any vdev (zfs term) size, I suspect only 2
of the 122 disks are parity.

If, how can I make the filesystem, so for every 6 disks, 2 of them are parity?

Reading the mkfs.btrfs man page gives me the impression that it can't
be done, which I find hard to believe.
