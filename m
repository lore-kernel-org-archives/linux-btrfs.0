Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21340ECDE44
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 18:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB2972075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 18:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="RQ83DvOA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB2972075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeJYCel (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 22:34:41 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42544 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbeJYCel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 22:34:41 -0400
Received: by mail-lj1-f196.google.com with SMTP id z9-v6so814899ljk.9
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 11:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=W+aiqjyl5fTqbatFihVfAo/ATeIOicBcuFyisxbhPlI=;
        b=RQ83DvOAMHXUVDG10iV8+UcM4wUTsyq6Dup6QK+BJA6T7t+4HHBZj48cOwzOzk4o6D
         gGFjn758pV5b+GSQiEwlSN+olEcYoqXidwC4MTcG55DgRsPHdMfiVU4zlcUlrKQpdQFt
         JCufA+fmBOU5jDp3FR6lxBItyaNB91ym3MlXfGkxFUKWYFHzWP9rb0yvc7z5eWCESP1f
         h2gOEwszXsCJtXG+tBCwLJO82LOJam1WgG/hZ6UrxaPbK9gokP/pMuRHLsFgLT3Dx3AI
         1lDqh2N8fe+QDc4zieugppD94Ddq2yhCQCo5cRV28nOYaiEEhLyy8fcKC42YBcYsNj/G
         UOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=W+aiqjyl5fTqbatFihVfAo/ATeIOicBcuFyisxbhPlI=;
        b=FHnX7fKjcKu2H3qNbHeSak9tJmq5382fqA+zuwGjuUaRsMe24gHicwF5PMJn67VDYB
         cJmrG4ixxnwm5hSXWNsahh9GhCfs9OD3KYhd0zRxzhnJCYQOqZxDOqtEatUveCpx+8Z0
         UqapzZFID8+LmG6gvS0PRyeFg7XQgcCp/eLl89MMbc6M33I4FsxlWl09OuPWy+vGh6SY
         nlpkYbCKwYCz20wOOale9CnEFBbh3iiCdgP+dR5UkhchBsNmh/NoApgXJ1n3lVLpqjS1
         o49R2Y6h+fhk5YY7UpMKJJl8yeP15fUNlEhEgE2ZaJqOBMT7QdFlywxZEa9PlNzFHbbI
         axJg==
X-Gm-Message-State: AGRZ1gK9rSGodMZRf4oomVuHMATfvT3w27xwJCF1jPYchNDOlTE/lCnz
        79NqdtKRBGFn/mf11CA+irUDxkWjymIZcf4MIUrSTQ==
X-Google-Smtp-Source: AJdET5dOK4pcKl29cyIcH/8mNj0TrttTkKGQ32O6efimhlDadrnMgQsu3UhoiNSNAcuS/B7cBiYj17r7OFUHUBCNLUs=
X-Received: by 2002:a2e:8606:: with SMTP id a6-v6mr2154582lji.43.1540404336857;
 Wed, 24 Oct 2018 11:05:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1990:0:0:0:0:0 with HTTP; Wed, 24 Oct 2018 11:05:36
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <3051750f58524cceed2a69fcf43bae31@mail.ru>
References: <dac5a4c5-e40d-a332-420f-f5517730a5f4@mail.ru> <3051750f58524cceed2a69fcf43bae31@mail.ru>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 24 Oct 2018 12:05:36 -0600
X-Google-Sender-Auth: Z6PG03bXsAmTzsNFagyAFY3-j_0
Message-ID: <CAJCQCtQqus2ytiBCe=TZsWNsBNDy-SR064r1bPsyC5hL3iaJKQ@mail.gmail.com>
Subject: Re: Failover for unattached USB device
To:     Dmitry Katsubo <dma_k@mail.ru>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 9:03 AM, Dmitry Katsubo <dma_k@mail.ru> wrote:
> On 2018-10-17 00:14, Dmitry Katsubo wrote:
>>
>> As a workaround I can monitor dmesg output but:
>>
>> 1. It would be nice if I could tell btrfs that I would like to mount
>> read-only
>> after a certain error rate per minute is reached.
>> 2. It would be nice if btrfs could detect that both drives are not
>> available and
>> unmount (as mount read-only won't help much) the filesystem.
>>
>> Kernel log for Linux v4.14.2 is attached.
>
>
> I wonder if somebody could further advise the workaround. I understand that
> running
> btrfs volume over USB devices is not good, but I think btrfs could play some
> role
> as well.

I think about the best we can expect in the short term is that Btrfs
goes read-only before the file system becomes corrupted in a way it
can't recover with a normal mount. And I'm not certain it is in this
state of development right now for all cases. And I say the same thing
for other file systems as well.

Running Btrfs on USB devices is fine, so long as they're well behaved.
I have such a setup with USB 3.0 devices. Perhaps I got a bit lucky,
because there are a lot of known bugs with USB controllers, USB bridge
chipsets, and USB hubs.

Having user definable switches for when to go read-only is, I think
misleading to the user, and very likely will mislead the file system.
The file system needs to go read-only when it gets confused, period.
It doesn't matter what the error rate is.

The work around is really to do the hard work making the devices
stable. Not asking Btrfs to paper over known unstable hardware.

In my case, I started out with rare disconnects and resets with
directly attached drives. This was a couple years ago. It was a Btrfs
raid1 setup, and the drives would not go missing at the same time, but
both would just drop off from time to time. Btrfs would complain of
dropped writes, I vaguely remember it going read only. But normal
mounts worked, sometimes with scary errors but always finding a good
copy on the other drive, and doing passive fixups. Scrub would always
fix up the rest. I'm still using those same file systems on those
devices, but now they go through a dyconn USB 3.0 hub with a decently
good power supply. I originally thought the drop offs were power
related, so I explicitly looked for a USB hub that could supply at
least 2A, and this one is 12VDC @ 2500mA. A laptop drive will draw
nearly 1A on spin up, but at that point P=AV. Laptop drives during
read/write using 1.5 W to 2.5 W @ 5VDC.

1.5-2.5 W = A * 5 V
Therefore A = 0.3-0.5A

And for 4 drives at possibly 0.5 A (although my drives are all at the
1.6 W read/write), that's 2 A @ 5 V, which is easily maintained for
the hub power supply (which by my calculation could do 6 A @ 5 V, not
accounting for any resistance).

Anyway, as it turns out I don't think it was power related, as the
Intel NUC in question probably had just enough amps per port. And what
it really was, was incompatibility between the Intel controller and
the bridgechipset in the USB-SATA cases, and the USB hub is similar to
an ethernet hub, it actually reads the USB stream and rewrites it out.
So hubs are actually pretty complicated little things, and having a
good one matters.

>
> In particular I wonder if btrfs could detect that all devices in RAID1
> volume became
> inaccessible and instead of reporting increasing "write error" counter to
> kernel log simply
> render the volume as read-only. "inaccessible" could be that if the same
> block cannot be
> written back to minimum number of devices in RAID volume, so btrfs gives up.

There are pending patches for something similar that you can find in
the archives. I think the reason they haven't been merged yet is there
haven't been enough comments and feedback (?). I think Anand Jain is
the author of those patches so you might dig around in the archives.
In a way you have an ideal setup for testing them out. Just make sure
you have backups...


>
> Maybe someone can advise some sophisticated way of quick checking that
> filesystems is
> healthy?

'btrfs check' without the --repair flag is safe and read only but
takes a long time because it'll read all metadata. The fastest safe
way is to mount it ro and read a directory recently being written to
and see if there are any kernel errors. You could recursively copy
files from a directory to /dev/null and then check kernel messages for
any errors. So long as metadata is DUP, there is a good chance a bad
copy of metadata can be automatically fixed up with a good copy. If
there's only single copy of metadata, or both copies get corrupt, then
it's difficult. Usually recovery of data is possible, but depending on
what's damaged, repair might not be possible.


-- 
Chris Murphy
