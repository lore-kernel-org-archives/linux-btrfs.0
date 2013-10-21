Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57649 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3JUPBo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 11:01:44 -0400
Received: by mail-pd0-f170.google.com with SMTP id v10so2412955pde.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 08:01:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131021123728.GJ1032@twin.jikos.cz>
References: <CA+yNr1dyhC1=Rv=wuzV-YzSdEOmEEB=OLo=SJwmSMvsvhmmZ-g@mail.gmail.com>
 <20131021123728.GJ1032@twin.jikos.cz>
From: david pu <pulq.ustc@gmail.com>
Date: Mon, 21 Oct 2013 23:01:14 +0800
Message-ID: <CA+yNr1cRipOhvkNsf8d2sR1bm1hdL6xLicBBFyiWTd=oaQjGHw@mail.gmail.com>
Subject: Re: task btrfs-transacti:1076 blocked for more than 120 seconds
To: dsterba@suse.cz, david pu <pulq.ustc@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 21, 2013 at 8:37 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Oct 21, 2013 at 04:36:41PM +0800, david pu wrote:
>> I'm running into btrfs-transaction hang issue with below call trace
>> from dmesg[1].
>> when this issue happens, all filesystem r/w access will be blocked and
>> no response in terminal. I'm using Ubuntu raring(linux 3.2 kernel)
>> 64bit kernel as below:
>> Linux dpu-e6410 3.2.0-36-generic #57-Ubuntu SMP Tue Jan 8 21:44:52 UTC
>> 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>> is it a known issue? How to recover from such task hung status?
>
> The message can occur when
>
> 1) system is under heavy load or fragmentation slows down the IO, this
> is harmless, the warnings stop after a few cycles
It happens after I login into Ubuntu with lightdm.I did not find a
method to reproduce it consistently.
>
> 2) it's a bug and the system cannot move forward due to a deadlock, the
> warnings appear repeatedly and the IO seems to be stalled
>
> For a 3.2 kernel it's possible that the bug is there.

I'm very sorry about the kernel version I pasted in previous email. I
pasted wrong uname -a result. it should be:
Linux dpu-desktop 3.8.0-31-generic #46-Ubuntu SMP Tue Sep 10 20:03:44
UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

will upgrade kernel to latest version to have a try.

>
> david



-- 
 ()   ASCII Ribbon Campaign
 /\   Keep it simple!
