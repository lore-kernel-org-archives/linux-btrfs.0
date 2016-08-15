Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36199 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbcHONkw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 09:40:52 -0400
Received: by mail-oi0-f50.google.com with SMTP id f189so59814858oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 06:40:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGQ70YdW+t_-vqj+uvyKMxoPLN__bxZ=b+S1oe7ujw3Ek0Cggg@mail.gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com> <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
 <a119738d-942b-4dca-265e-5f9db15e2893@gmail.com> <CAGQ70YdW+t_-vqj+uvyKMxoPLN__bxZ=b+S1oe7ujw3Ek0Cggg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 15 Aug 2016 07:40:50 -0600
Message-ID: <CAJCQCtR5C_6wuATVs6=RsrjBCf=d-ssCdLiYZVmBtszrZdCG3Q@mail.gmail.com>
Subject: Re: How to stress test raid6 on 122 disk array
To: Martin <rc6encrypted@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 15, 2016 at 6:19 AM, Martin <rc6encrypted@gmail.com> wrote:

>
> I have now had the first crash, can you take a look if I have provided
> the needed info?
>
> https://bugzilla.kernel.org/show_bug.cgi?id=153141

[337406.626175] BTRFS warning (device sdq): lost page write due to IO
error on /dev/sdap

Anytime there's I/O related errors that you'd need to go back farther
in the log to find out what really happened. You can play around with
'journalctl --since' for this. It'll accept things like -1m or -2h for
"back one minute or back two hours" or also "today" "yesterday" or by
explicit date and time.



-- 
Chris Murphy
