Return-Path: <SRS0=vUl+=QK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D45CC169C4
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 18:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C36721773
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 18:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="qJXMdCB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfBCSn4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 Feb 2019 13:43:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42662 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfBCSnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Feb 2019 13:43:55 -0500
Received: by mail-lf1-f68.google.com with SMTP id l10so8672138lfh.9
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Feb 2019 10:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PGNjaW5ouWS9OMZojtzla5NVqeUVK+9NarSxpZjBZ4s=;
        b=qJXMdCB80jnHKI2N5H1Nn41LrDbgbrKWvojQ9FPuLyRUXVOTpHCiaoV85EZL1b2X4+
         PAUzRYkDZ7QiKbADBppm1i7Fj30mPbC6YEHW5JqS+/HzBn3MzPq126iM0sr2YWcKTObu
         jbLDI+h1bnIlpx0WKbl2sXlpiFznFSUp8Dnyt3Ke9V3Lt5Uya8T0xRxNL6jTjC8q1W1o
         np3deoSLh63piyNnGAfN07sX9xdhzIrgTR3z/zkaf8NukI5Q+d8w75B5261aqVE6x+S0
         HcDnmo9Cx5tVGIikBhBNJj5hRULN8ZLevwE1Hs0JQ9S0OSX4X7XsIYhPjAbZc1yn2Bhd
         SIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PGNjaW5ouWS9OMZojtzla5NVqeUVK+9NarSxpZjBZ4s=;
        b=PCzEeqnKU9OCYeV3Zg1Jo3US8BS8U2fEJ8DTLR8mCTl0I2pUIjeE7+0bGo2keuo/kY
         AS1BqPRoHrXf+reLd5yNX+mtOb1DqWbwpDz1NlJBcIPIs4fi14PO2bFeW1SpJjcyfGO4
         +XSEQWQ1j1UAjmYpuK/lflxIHEJ5h4vaoHn5zSmzQAG2L0KNBXKESSZUDjQLU2hqSWZE
         2NRIwC/WhBoDM5rpGsEQwYXEPZIWrMcFha3dDFLEnW36xMnEndXpUD7GsVCVhejCxgPH
         WhCXLO1HxV0QDei/tulSI7+EmRMLMV4aDYdECuLoqsE9wR9RAHfAislAa11RQkl9he0e
         YN2g==
X-Gm-Message-State: AHQUAuZxDOb7OAlfsFA14TgmFAPIVeHUD4uTelZKsp8xzeuNRF0sWvzX
        qyWE94seLuVXj9PV6mMFKSCemu3bN+aIrL4eT+eQ9Q==
X-Google-Smtp-Source: AHgI3IZZmj1k8VVzbECSNE14xHWYClm3QKVN2vcwzJS2UOxWSPht/j9AEUv9udpxYFh2dnuxrOJsKaZhmXH+MZt09N8=
X-Received: by 2002:ac2:4116:: with SMTP id b22mr5503114lfi.19.1549219432848;
 Sun, 03 Feb 2019 10:43:52 -0800 (PST)
MIME-Version: 1.0
References: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
 <20190202120149.GE4461@carfax.org.uk> <CAJCQCtRL4bd+2_g8+YZ5uV254E_nK3OxS9Q0AB5dqN-N4zcd0Q@mail.gmail.com>
 <276ebe4c-2d16-4850-8aa1-32794f3f2502@www.fastmail.com>
In-Reply-To: <276ebe4c-2d16-4850-8aa1-32794f3f2502@www.fastmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 3 Feb 2019 11:43:41 -0700
Message-ID: <CAJCQCtTtdR42gYACKXaPMM4Z6w3JDPTU4RqGufh=fK5TCVkS=w@mail.gmail.com>
Subject: Re: RAID1 filesystem not mounting
To:     Alan Hardman <alanh@fastmail.com>
Cc:     Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 2, 2019 at 10:40 PM Alan Hardman <alanh@fastmail.com> wrote:

> # journalctl | grep -A 15 exception
> ...
> Jan 23 01:06:37 localhost kernel: ata3.00: status: { DRDY }
> Jan 23 01:06:37 localhost kernel: ata3.00: failed command: WRITE FPDMA QU=
EUED
> Jan 23 01:06:37 localhost kernel: ata3.00: cmd 61/b0:98:ea:7a:48/00:00:0a=
:00:00/40 tag 19 ncq dma 90112 out
>                                            res 40/00:00:00:00:00/00:00:00=
:00:00/00 Emask 0x4 (timeout)
> --
> Jan 31 19:24:32 localhost kernel: ata5.00: exception Emask 0x0 SAct 0x0 S=
Err 0x0 action 0x6 frozen
> Jan 31 19:24:32 localhost kernel: ata5.00: failed command: READ DMA EXT
> Jan 31 19:24:32 localhost kernel: ata5.00: cmd 25/00:08:a8:2a:81/00:00:a3=
:03:00/e0 tag 0 dma 4096 in
>                                            res 40/00:01:00:00:00/00:00:00=
:00:00/10 Emask 0x4 (timeout)
> Jan 31 19:24:32 localhost kernel: ata5.00: status: { DRDY }
> Jan 31 19:24:32 localhost kernel: ata5: link is slow to respond, please b=
e patient (ready=3D0)
> Jan 31 19:24:32 localhost kernel: ata5: device not ready (errno=3D-16), f=
orcing hardreset
> Jan 31 19:24:32 localhost kernel: ata5: soft resetting link

This kind of error on read is common when there is a marginally bad
sector, and the drive is doing deep recovery, and the time for
recovery is longer than the SCSI command timer. The reset clears the
command queue, meaning it's no longer possible to find out what sector
is marginal, and Btrfs can't fix it up. When left for a long time, it
allows bad sectors to accumulate, including during scrubbing. I don't
actually know what Btrfs does in this case, if the scrub is aborted,
or if it continues and shows the error as uncorrectable.

This isn't the only possible explanation for this kind of error. But
the bottom line is that it's generic, indicates there is a problem,
and you need to find out what the real cause is. It's asking for
trouble to just leave this kind of error floating in the wind, even if
it seems like everything is otherwise working.


> Jan 31 19:24:32 localhost kernel: ata5.00: configured for UDMA/33
> Jan 31 19:24:32 localhost kernel: ata5.01: configured for UDMA/33
> Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 FAILED Result: =
hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 Sense Key : Ill=
egal Request [current]
> Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 Add. Sense: Una=
ligned write command
> Jan 31 19:24:32 localhost kernel: sd 4:0:0:0: [sde] tag#0 CDB: Read(16) 8=
8 00 00 00 00 03 a3 81 2a a8 00 00 00 08 00 00
>

I don't know what the portion of this error sequence means, "illegal
request" and "unaligned write command". On 512e Advanced Format hard
drives, which have 512 byte logical 4096 byte physical sectors, a 512
byte write must actually be converted to 4096 byte read by the drive
firmware in order to do a read write modify. It can't do an overwrite
of just those 512 bytes. If there's a problem reading that sector, it
comes back as a read error. But... I'm not sure any of that is what
this is. To my knowledge Btrfs never does 512 byte writes, the minimum
read or write is 4096 bytes. Moving on...

From your attached log, there are lots of failed writes. That really
must be sorted out because for all raid, write failures are fatal.
With md based raid, it'll eject the drive as faulty on a single write
failure. Whereas Btrfs keeps trying, as it has no concept of faulty
drives still. So you've got recent missing writes to whatever drive
has all these write errors. The 'grep -A 15' limited the output so I
can't tell how the error ended up being handled either by libata or
Btrfs. You really need to find out what device has write problems as
the next priority, as this is decently likely to prevent any 'btrfs
check --repair' from succeeding.

Next the SCSI command timer (this is a kernel timeout per block
device) for all devices is the default of 30 seconds. Most drives have
SCT ERC of 70 deciseconds which is *good*. But two drives do not, and
instead I see:

SCT Error Recovery Control command not supported

That's not good because it's possible marginally bad sectors will
cause the drive firmwar

Next, one of those drives has some UDMA errors which suggests an
actual link problem between the drive's controller and the logic
board's controller - the most logical suspect is just reseating the
cable on both ends. But maybe the cable needs replacing. So you'll
want to keep an eye on whether these errors continue or not. They'll
trigger a libata error message and it'll either retry or reset the
link, and therefore might be what caused one of your link reset
errors.

199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    19

OK so you have a corrupt leaf probably from bad memory, which probably
corrupted both copies of the leaf, which is why we don't see any fixup
messages. I don't actually know if 'btrfs check --repair' can fix this
kind of bad memory induced corruption. But in any case, we've got to
get the other hardware problems figured out before a repair is assured
to stick.

> I have been able to successfully recover files via "btrfs restore ...", a=
nd there doesn't seem to be anything essential missing from its full output=
 with -D, so if that's necessary to use to offload the entire filesystem, i=
t at least seems possible if it can't be recovered directly.

If the data is important, and if this is the only copy, I always argue
in favor of urgently making a backup. Set aside all other
troubleshooting.

--=20
Chris Murphy
