Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35915 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcHONng (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 09:43:36 -0400
Received: by mail-oi0-f48.google.com with SMTP id f189so59903431oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 06:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGQ70YeK3ZRqL6XgnqQnb4KwGyiOhG5Oavjhu6_L+VhE+uO2sQ@mail.gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com> <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
 <a119738d-942b-4dca-265e-5f9db15e2893@gmail.com> <CAGQ70YdW+t_-vqj+uvyKMxoPLN__bxZ=b+S1oe7ujw3Ek0Cggg@mail.gmail.com>
 <71a331cf-b8cf-73f0-74a2-db09a21e5d04@gmail.com> <CAGQ70YeK3ZRqL6XgnqQnb4KwGyiOhG5Oavjhu6_L+VhE+uO2sQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 15 Aug 2016 07:43:34 -0600
Message-ID: <CAJCQCtSNgy_8XOi-nibf7g0-W6qrws48tAW4vtcOUKOdd0x9hA@mail.gmail.com>
Subject: Re: How to stress test raid6 on 122 disk array
To: Martin <rc6encrypted@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 15, 2016 at 7:38 AM, Martin <rc6encrypted@gmail.com> wrote:
>> Looking at the kernel log itself, you've got a ton of write errors on
>> /dev/sdap.  I would suggest checking that particular disk with smartctl, and
>> possibly checking the other hardware involved (the storage controller and
>> cabling).
>>
>> I would kind of expect BTRFS to crash with that many write errors regardless
>> of what profile is being used, but we really should get better about
>> reporting errors to user space in a sane way (making people dig through
>> kernel logs to figure out their having issues like this is not particularly
>> user friendly).
>
> Interesting!
>
> Why does it speak of "device sdq" and /dev/sdap ?
>
> [337411.703937] BTRFS error (device sdq): bdev /dev/sdap errs: wr
> 36973, rd 0, flush 1, corrupt 0, gen 0
> [337411.704658] BTRFS warning (device sdq): lost page write due to IO
> error on /dev/sdap
>
> /dev/sdap doesn't exist.

OK well
journalctl -b | grep -A10 -B10 "sdap"

See in what other context it appears. And also 'btrfs fi show' and see
if it appears associated with this Btrfs volume.

-- 
Chris Murphy
