Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7087ECDE46
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 18:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD8820652
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 18:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="BX4GErPX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CD8820652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbeJZDIu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 23:08:50 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:38308 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeJZDIu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 23:08:50 -0400
Received: by mail-lf1-f48.google.com with SMTP id x24-v6so7583260lfe.5
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 11:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=7NPI67bYK40k8gZr/i0TKucdOmZpF/1F7PoM5zOMEJA=;
        b=BX4GErPXXJa3TThrowyP6wq00p7YCV85jCTOoy0ysRoBybHl5zL7dW17Wwkn9CgjSj
         QF01Nb1LmqPHJaaB1ECjrs0M9LJ9vtmr46lKipUG3orEHZ+0HemM083TDpD1yD8RViOC
         Z0Jw2NbatrtumHJWuIKroUC+fidYMXzP6hdlA9iUn0m/lTUuUYMSuRy+j6BZxxnxeAmF
         EREV+g/Nrc43PdVvKjSfGFR/ln/buNIvk1WM6HlzN9UJb4A0JabjcDMHHqE+sjzeSdTA
         CRziYudWw5peEScw61wZtyaXloS5RjZo1izs6HPEpeU59+PPWu89tAouu/tiJFIq09uG
         QWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=7NPI67bYK40k8gZr/i0TKucdOmZpF/1F7PoM5zOMEJA=;
        b=rwkwo3VyJuYvK/7k0je7HVaRT2YrPEc7qQurX8r3ZinvvtM6/nFGjBP/4C73tD2BH9
         1bZqYab+eeRz+YMh1dakwT5qNwFQe2wr9e5a3YVGSquJ5vLoJnbH7FtYgyn25PEedube
         kvKpx+WYHloWKKccx7g10GyHhDvlsgDR4JRIyfc9bkjZJuzRDO7p88lUzo77CTlTDL6q
         P6zkGeu/2i3vPrA04LEMioSX2BRZM3BVfhi8E39UpshcFp5RrojbAs/cuv05qn2VW4VU
         p4hBPNqG1rVKPTEkdu7H0VIJ56x986BhI3qrJ1S1eDCIaoyuWARnzMPUMaicuRmP5sdH
         W18Q==
X-Gm-Message-State: AGRZ1gK1th2l528xFNwMBmvgOMGZo0zyfxbJfHChY5ayjybP8gN5ZLGq
        1d0TIE0EZnixjjF2zMmavAql0W6Y0KOi7hn9qAXLNw==
X-Google-Smtp-Source: AJdET5eOivUiPyj3cRZUTCvUMcrJmD5j4XS9Vex73+TmIVOSQRJZRySarZc1QBvl6Mt28kjOXIJDVMO6G1sIUj6mKDI=
X-Received: by 2002:a19:d612:: with SMTP id n18-v6mr231133lfg.4.1540492494027;
 Thu, 25 Oct 2018 11:34:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:6f0e:0:0:0:0:0 with HTTP; Thu, 25 Oct 2018 11:34:53
 -0700 (PDT)
X-Originating-IP: [174.29.142.179]
In-Reply-To: <e3d54b3d15a57d8fcd34e7a5bb9139c1@mail.ru>
References: <dac5a4c5-e40d-a332-420f-f5517730a5f4@mail.ru> <3051750f58524cceed2a69fcf43bae31@mail.ru>
 <CAJCQCtQqus2ytiBCe=TZsWNsBNDy-SR064r1bPsyC5hL3iaJKQ@mail.gmail.com> <e3d54b3d15a57d8fcd34e7a5bb9139c1@mail.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 25 Oct 2018 12:34:53 -0600
X-Google-Sender-Auth: Wnnb_nOvKZMWKGsUSxX_VLCYi9s
Message-ID: <CAJCQCtQPBF0XxO5oGi_JM-VLiLmKCDMas_Q-genUZrYSnFjfsQ@mail.gmail.com>
Subject: Re: Failover for unattached USB device
To:     Dmitry Katsubo <dma_k@mail.ru>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 25, 2018 at 3:47 AM, Dmitry Katsubo <dma_k@mail.ru> wrote:
>
>
> BTRFS error (device sdf): bdev /dev/sdh errs: wr 0, rd 1867, flush 0,
> corrupt 0, gen 0
> BTRFS error (device sdf): bdev /dev/sdg errs: wr 0, rd 1867, flush 0,
> corrupt 0, gen 0
>
> Attempts lasted for 29 minutes.

Yep, and it floods the log. It's extra fun if the journal is on the
device with errors. The more errors, the more writes and reads to the
problem drive, the more errors, the more writes, the more errors...
snowball.

But that's the state of error handling on Btrfs, which is still more
sophisticated than other file systems. It's not more sophisticated
than the kernel's md driver, which does have some sort of read error
rate limit and then it'll kick the drive out of the array (faulty
state) and stop complaining about it. And I think it considers a drive
faulty on a single write failure.

>
> Thanks for this information. I have a situation similar to yours, with
> only important difference that my drives are put into the USB dock with
> independent power and cooling like this one:
>
> https://www.ebay.com/itm/Mediasonic-ProBox-4-Bay-3-5-Hard-Drive-Enclosure-USB-3-0-eSATA-Sata-3-6-0Gbps/273161164246
>
> so I don't think I need to worry about amps. This dock is connected
> directly to USB port on the motherboard.

It is entirely plausible that this still needs a hub, but it really
depends on the exact errors you're getting. And those need to go to
the linux-usb list, I don't know enough about it.

And it might require a bit of luck to get a reply because it's a very
busy list. My main recommendation is to be very concise: They will
want to know the hardware setup (topology), lsusb -v, lspci, and a
complete dmesg. It'll seem reasonable to snip just to the usb error
messages, that almost always drives developers crazy because important
hints for problems can show up in kernel message during boot, so they
will inevitably want the whole dmesg. Ideal scenario is to do a clean
boot and then reproduce the problem, and then capture the dmesg, that
way it's a concise dmesg that isn't two weeks old with a bunch of
device connects and disconnects or whatever. There almost certainly
will be usb kernel parameters for debugging, ideally you search the
linux-usb list archives to find out what they are (I'm not sure) so
that you already have that set for your clean boot.

There might be usb quirks for your hardware setup that apply. Or they
might suggests that it still needs a  USB hub to clean things up
between controller and bridge chipset.



>
> However indeed there could be bugs both on dock side and in south bridge.
> More over I could imagine that USB reset happens due to another USB device,
> like a wave stated in one place turning into tsunami for the whole
> USB subsystem.

If there is a hub, one of their jobs is to prevent that from
happening. And if the drive enclosure and problem device are on
separate ports, they are effectively going through a built-in hub in
the usb host device. But yeah, you want to tell linux-usb exactly what
devices (and chipsets which lsusb -v will show)  you're using because
they may already know about such problems.


>
>> There are pending patches for something similar that you can find in
>> the archives. I think the reason they haven't been merged yet is there
>> haven't been enough comments and feedback (?). I think Anand Jain is
>> the author of those patches so you might dig around in the archives.
>> In a way you have an ideal setup for testing them out. Just make sure
>> you have backups...
>
>
> Thanks for reference. Should I look for this patch here:
>
> https://patchwork.kernel.org/project/linux-btrfs/list/?submitter=34632&order=-date

Maybe, it's a lot of patches to go through. I'm using
https://lore.kernel.org/linux-btrfs which has a search field.

This is the recent email I was thinking of that might point you in the
right direction:

https://lore.kernel.org/linux-btrfs/2287c62d-6dbb-3b30-1134-d754e42941ab@oracle.com/

A complicating factor is that the block layer does do some retries.
I'm also not familiar enough with the way md does retries and sets
drives as faulty and if that is really what Btrfs should replicate or
not. Some of these conversations require cooperation with other kernel
developers, I suspect, like libata, SCSI, USB, SD, in order to make
sure no one is being stepped on with some big surprise.



>
> I didn't observe any errors while doing "btrfs check" on this volume after
> several such resets, because that volume is mostly used for reading and
> chance that USB reset happens during the write is very low.

If it mounts and the most recent changes are readable without errors,
the file system is probably fine. Btrfs is pretty good at detecting
and correcting for hardware related problems, in that it is fussier
than other file systems because it can detect such problems in both
metadata and data and should be able to avoid them in the first place
due to always on COW (as long as you haven't disabled it).

But there is some evidence that old Btrfs bugs could induce corruption
in metadata, and not turn into a problem for a long time later. The
scrubs only check if metadata and its checksum match up (corruption
detection elsewhere in the storage stack) so the scrub most often
can't find bugs that cause corruption. You best bet for side stepping
such problems is backups, and using the most recent kernel you can. If
you encounter some problem that might be a bug, inevitably you'll need
to test with a newer kernel version anyway to see if it's still a bug.
Each merge cycle involves thousands of lines of changes just for Btrfs
and there's more to the storage stack in the kernel than just Btrfs.

In your use case with mostly reads, and probably you also don't care
about write performance, you could consider mounting with notreelog.
This will drop the use of the treelog which is used to improve
performance on operations that use fsync. With this option,
transactions calling fsync() fall back to sync() so it's safer but
slower.


-- 
Chris Murphy
