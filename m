Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36671 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbGBOtX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 10:49:23 -0400
Received: by oiaf66 with SMTP id f66so25890439oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 07:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
 <CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
 <CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
 <CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
 <CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
 <CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
 <CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
 <CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com> <CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Thu, 2 Jul 2015 09:49:03 -0500
Message-ID: <CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

At the bottom of this email are the results of the latest
chunk-recover.  I only included one example of the output that was
printed prior to the summary information but it went up to the end of
my screen buffer and beyond.

So it looks like the command executed properly when none of the drives
give up on a read.  That said my issue with mounting still exists
unfortunately.  The errors in dmesg now complain about /dev/sdd.

[56496.014539] BTRFS (device sdd): bad tree block start 0 21364736

Which is curious because this is device id 2, where previously the
complaint was about device id 1.  So can I believe dmesg about which
drive is actually the issue or is the drive that's printed in dmesg
just whichever drive happens to be the last in some loop of code?
Theoretically I should be able to kick another drive out of the pool
safely, but I'm not sure which one to actually kick out or if that is
the appropriate next step.

I do see plenty of complaints about the sdg drive (previously sde) in
/var/log/messages from the 28th which is when I started noticing
issues.  Nothing is jumping out at me claiming the btrfs is taking
action but I may not know what to look for.

journalctl I'm not familiar with.  journalctl -bX returns with "failed
to parse relative boot ID number 'X'" but perhaps you meant X to be a
variable of some value?    journalctl -b does run, but I'm not sure
what to look for.

So, what does the audience suggest?  Shall I compile a newer kernel,
kick out another drive (which?), or take what's behind door #3 (which
is...?)

Thanks again everybody,
Donald

  Chunk: start = 6643489177600, len = 1073741824, type = 104, num_stripes = 10
      Stripes list:
      [ 0] Stripe: devid = 8, offset = 817549672448
      [ 1] Stripe: devid = 7, offset = 817549672448
      [ 2] Stripe: devid = 10, offset = 817549672448
      [ 3] Stripe: devid = 9, offset = 817549672448
      [ 4] Stripe: devid = 3, offset = 817549672448
      [ 5] Stripe: devid = 0, offset = 0
      [ 6] Stripe: devid = 0, offset = 0
      [ 7] Stripe: devid = 0, offset = 0
      [ 8] Stripe: devid = 0, offset = 0
      [ 9] Stripe: devid = 0, offset = 0
      Block Group: start = 6643489177600, len = 1073741824, flag = 104
      Device extent list:
          [ 0]Device extent: devid = 3, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 1]Device extent: devid = 9, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 2]Device extent: devid = 10, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 3]Device extent: devid = 7, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 4]Device extent: devid = 8, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 5]Device extent: devid = 4, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 6]Device extent: devid = 2, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 7]Device extent: devid = 1, start = 817569595392, len =
134217728, chunk offset = 6643489177600
          [ 8]Device extent: devid = 6, start = 817549672448, len =
134217728, chunk offset = 6643489177600
          [ 9]Device extent: devid = 5, start = 817549672448, len =
134217728, chunk offset = 6643489177600
  Chunk: start = 6886154829824, len = 8589934592, type = 101, num_stripes = 0
      Stripes list:
      Block Group: start = 6886154829824, len = 8589934592, flag = 101
      No device extent.
  Chunk: start = 6894744764416, len = 8589934592, type = 101, num_stripes = 0
      Stripes list:
      Block Group: start = 6894744764416, len = 8589934592, flag = 101
      No device extent.
  Chunk: start = 6903334699008, len = 8589934592, type = 101, num_stripes = 0
      Stripes list:
      Block Group: start = 6903334699008, len = 8589934592, flag = 101
      No device extent.

Total Chunks:           805
  Recoverable:          567
  Unrecoverable:        238

Orphan Block Groups:

Orphan Device Extents:
  Device extent: devid = 4, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 2, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 1, start = 819851296768, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 9, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 10, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 8, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 7, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 3, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 6, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608
  Device extent: devid = 5, start = 819831373824, len = 1073741824,
chunk offset = 6661742788608

open with broken chunk error
Fail to recover the chunk tree.

On Wed, Jul 1, 2015 at 9:31 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Jul 1, 2015 at 7:38 PM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>
>> Here's the drive vomiting in my logs after it got halfway through the
>> dd image attempt.
>>
>> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] FAILED Result:
>> hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] Sense Key : Medium
>> Error [current]
>> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] Add. Sense:
>> Unrecovered read error
>> Jul  1 17:05:51 san01 kernel: sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a
>> 5b f1 e0 00 01 00 00
>> Jul  1 17:05:51 san01 kernel: blk_update_request: critical medium
>> error, dev sdg, sector 1515975136
>> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] FAILED Result:
>> hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] Sense Key : Medium
>> Error [current]
>> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] Add. Sense:
>> Unrecovered read error
>> Jul  1 17:05:57 san01 kernel: sd 0:0:6:0: [sdg] CDB: Read(10) 28 00 5a
>> 5b f2 e0 00 01 00 00
>
> This looks like a typical URE. There are a number of reasons why a
> sector can be bad, but basically the drive ECC has given up being able
> to correct the problem, and it reports the command, the error, and the
> sector involved. What *should* happen is Btrfs reconstructs the data
> (or metadata) on that sector, and then writes it (since kernel 3.19)
> back to the bad sector LBA. The drive tries to write to that bad
> sector, and verifies. If there is a persistent failure then that LBA
> is mapped to a different physical sector and the bad one is removed
> (has no LBA) - there will be no kernel messages for this it's all
> handled in the drive itself.
>
> But this sounds like a dd read of the raw device, where Btrfs is not
> involved (because you can't mount the volume) so none of this
> correction happens. What I wonder though it in the much earlier logs,
> if this same problem happened when the volume was mounted, did Btrfs
> try to fix the problem and were there problems fixing it?
>
> So it might be useful if there's something in /var/log/messages or
> journalctl -bX at the time the original problem was first developing.
>
> Bad sectors are completely ordinary. They're not really common, out of
> maybe 50 drives I've had two exhibit this. But the drive's are
> designed to take this into account, and so are hardware, and linux
> kernel md raid, and LVM raid, and Btrfs, and ZFS. So... it's kinda
> important to know more about this edge case to find out where the
> problem is.
>
>
>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
