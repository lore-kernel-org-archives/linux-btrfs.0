Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f53.google.com ([209.85.216.53]:37229 "EHLO
	mail-vn0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbbGBCbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 22:31:52 -0400
Received: by vnbf129 with SMTP id f129so9337257vnb.4
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 19:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
	<CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
	<CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
	<CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
	<CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
	<CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
	<CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
	<CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
Date: Wed, 1 Jul 2015 20:31:51 -0600
Message-ID: <CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 1, 2015 at 7:38 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:

> Here's the drive vomiting in my logs after it got halfway through the
> dd image attempt.
>
> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] FAILED Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] Sense Key : Medium
> Error [current]
> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] Add. Sense:
> Unrecovered read error
> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a
> 5b f1 e0 00 01 00 00
> Jul  1 17:05:51 san01 kernel: blk_update_request: critical medium
> error, dev sdg, sector 1515975136
> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] FAILED Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] Sense Key : Medium
> Error [current]
> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] Add. Sense:
> Unrecovered read error
> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a
> 5b f2 e0 00 01 00 00

This looks like a typical URE. There are a number of reasons why a
sector can be bad, but basically the drive ECC has given up being able
to correct the problem, and it reports the command, the error, and the
sector involved. What *should* happen is Btrfs reconstructs the data
(or metadata) on that sector, and then writes it (since kernel 3.19)
back to the bad sector LBA. The drive tries to write to that bad
sector, and verifies. If there is a persistent failure then that LBA
is mapped to a different physical sector and the bad one is removed
(has no LBA) - there will be no kernel messages for this it's all
handled in the drive itself.

But this sounds like a dd read of the raw device, where Btrfs is not
involved (because you can't mount the volume) so none of this
correction happens. What I wonder though it in the much earlier logs,
if this same problem happened when the volume was mounted, did Btrfs
try to fix the problem and were there problems fixing it?

So it might be useful if there's something in /var/log/messages or
journalctl -bX at the time the original problem was first developing.

Bad sectors are completely ordinary. They're not really common, out of
maybe 50 drives I've had two exhibit this. But the drive's are
designed to take this into account, and so are hardware, and linux
kernel md raid, and LVM raid, and Btrfs, and ZFS. So... it's kinda
important to know more about this edge case to find out where the
problem is.



-- 
Chris Murphy
