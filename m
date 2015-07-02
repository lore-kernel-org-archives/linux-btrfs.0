Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36467 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbGBSUB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 14:20:01 -0400
Received: by oiaf66 with SMTP id f66so30462729oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 11:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTE2QKQij5ziq_wWM=M0bhVKcxAbWVGOPD=R_1ZkvqWPA@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
 <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
 <CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
 <CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
 <CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
 <CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
 <CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
 <CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
 <CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
 <CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com> <CAJCQCtTE2QKQij5ziq_wWM=M0bhVKcxAbWVGOPD=R_1ZkvqWPA@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Thu, 2 Jul 2015 13:19:41 -0500
Message-ID: <CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately btrfs image fails with "couldn't read chunk tree".

btrfs restore complains that every device is missing except the one
that you specify on executing the command.  Multiple devices as a
parameter isn't an option.  Specifcy /dev/disk/by-uuid/<uuid> claims
that all devices are missing.

I went ahead and dropped the drive that dmesg is still complaining
about.  Mounting still fails, so I'm going to try to rescue chunk-tree
again (for science!).

If anybody has any other ideas to try or data to gather/methods to
gather them as a case study for any devs please let me know.  I'll
assemble all the data that I know how to and follow that link Chris
suggested for filing a bug.

On Thu, Jul 2, 2015 at 12:00 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Jul 2, 2015 at 8:49 AM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>
>> I do see plenty of complaints about the sdg drive (previously sde) in
>> /var/log/messages from the 28th which is when I started noticing
>> issues.  Nothing is jumping out at me claiming the btrfs is taking
>> action but I may not know what to look for.
>
> I'd include that entire log with the bug report. I'd like to skim it
> at least. Even logs from earlier might be useful.
>
>
> --
> Chris Murphy
