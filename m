Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6F0C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 00:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F81621741
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 00:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="uOTv6UN3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbeL0Agd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Dec 2018 19:36:33 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46770 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbeL0Agd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Dec 2018 19:36:33 -0500
Received: by mail-lf1-f67.google.com with SMTP id f23so11700417lfc.13
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Dec 2018 16:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2+ToUOKpwrJa2C5nzCgwhEOtIrEnknXg9y7KbSi7gk=;
        b=uOTv6UN3wPQSiZkN2H4F8A2iYqCnfG6noGWp3AUuLzXMU8ZrxBzg4jP948KdiWUO2Q
         IFTuksTHAxWsPAqINkogBPVgDIGUjl5TdtqmnZg9xLgrzmlDIfZ5IfO/RjYawFlTMTlR
         zXcziMrPSatd+hzARiSTP0/+uEHuPzvSplNyr8XPVaaoIJyUuJJ951UC9EhpNjTNhtuF
         y5Xr5Xd5qMlAx0YKsJCp5lr7Mh3vlJyoX+zinEkTzOwRryXqRbTAoJG/rxCYtst+fW0i
         psJpy3bLCg3qw7CMOloMUDhNjttF2eQEa9U3blTzomfJHA3gl6lSBWpF8d9DNkAp7XIC
         7qFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2+ToUOKpwrJa2C5nzCgwhEOtIrEnknXg9y7KbSi7gk=;
        b=qGSSkR+nxb1+BO/Xohah9mFEmFqCeLbHPw8njVt8sj8XbwM8nSc0VSOqtQ+LeG/6L5
         mZQamTvfrspPwHngixDu2KtT4DdgD81lFdoV6IzPnZy+oNTFJFnGjRzUFNTOYAL4MaeF
         FMlaw0oQtFqkMVftTXeKcyXlRETdHW5DnlvKrS3bEALFvnqXYfD6lhmRK95907rj9kMZ
         vhZhDNMSGbMO00QcRNIGgSarTryxbhQpZHlbZk0VNRYbN+gIT13/giPWSZecHvXqKYud
         12RhuyL4jakuwrlocm80TcRnWCJmbycFvAADsjwMs35XQhEadweMtzYaq/geZY27gt2k
         FCsQ==
X-Gm-Message-State: AA+aEWYtH8cVmVn6nd2M71EVTtFzKqtF7km0ZktmNNicWxGQPmQGYRd/
        aWaTo9xBXGKJOyg8mpU6F/sbxNyv/DCepQ4lFMO3CQ==
X-Google-Smtp-Source: AFSGD/VU4uoh0kuigiFmoEZSjUISLzR2OxWJXDZ8TXhfhFRPDOT8WS3UC5cMdEQcuoVz5JCP2LRU/kURqPjCt1gGUP4=
X-Received: by 2002:a19:f89:: with SMTP id 9mr10479656lfp.10.1545870990676;
 Wed, 26 Dec 2018 16:36:30 -0800 (PST)
MIME-Version: 1.0
References: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net>
In-Reply-To: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 26 Dec 2018 17:36:19 -0700
Message-ID: <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
To:     joshua@mailmag.net
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 24, 2018 at 10:21 AM <joshua@mailmag.net> wrote:
>
> I generally use this command to check my drive usage: `btrfs fi usage -T /mnt/data` But this time
> it didn't give me useful information:
>
> I decided to begin replacing a few of my drives with larger drives, so I could remove a lot of my
> smaller drives. I ran this command:
> Overall:
> Device size: 67.31TiB
> Device allocated: 41.73TiB
> Device unallocated: 25.58TiB
> Device missing: 0.00B
> Used: 41.69TiB
> Free (estimated): 12.81TiB (min: 12.81TiB)
> Data ratio: 2.00
> Metadata ratio: 2.00
> Global reserve: 512.00MiB (used: 0.00B)
>
> Data Metadata System
> Id Path RAID1 RAID1 RAID1 Unallocated
> -- -------- -------- -------- -------- -----------
> 4 /dev/sda 2.57TiB 3.00GiB - 164.52GiB
> {-snip-}
>
> I then started the replace with this command: `btrfs replace start 4 /dev/sdu /mnt/data`
> Everything went well, so I checked again:
> root@CENTAUR:~# btrfs fi usage -T /mnt/data
> Overall:
> Device size: 67.31TiB
> Device allocated: 41.73TiB
> Device unallocated: 25.58TiB
> Device missing: 0.00B
> Used: 41.69TiB
> Free (estimated): 12.81TiB (min: 12.81TiB)
> Data ratio: 2.00
> Metadata ratio: 2.00
> Global reserve: 512.00MiB (used: 0.00B)
>
> Data Metadata System
> Id Path RAID1 RAID1 RAID1 Unallocated
> -- -------- -------- -------- -------- -----------
> 4 /dev/sdu 2.57TiB 3.00GiB - 6.53TiB
> {-snip-}
>
> For a brief moment I was confused, and ran this command to double-check:
> root@CENTAUR:~# btrfs fi sh
> Label: 'DATA' uuid: ddafe51b-e1e8-4f4b-bcca-057f53b59a8d
> Total devices 17 FS bytes used 20.84TiB
> {-snip-}
> devid 4 size 2.73TiB used 2.57TiB path /dev/sdu
> {-snip-}
>
> Oh right, I have to run resize! So I run resize, and everything works exactly as expected.
>
> However, shouldn't `btrfs fi usage -T` only report the usable space in the unallocated column?
> `btrfs fi sh` only reports the available space correctly.
> Perhaps there is a reason for this behavior? If not, it's a little confusing, and should really be
> brought into line with `btrfs fi sh` IMO.
>
> For reference, here is what I ran afterwards:
>
> root@CENTAUR:~# btrfs fi resize 4:max /mnt/data
> Resize '/mnt/data' of '4:max'
> root@CENTAUR:~# btrfs fi sh
> Label: 'DATA' uuid: ddafe51b-e1e8-4f4b-bcca-057f53b59a8d
> Total devices 17 FS bytes used 20.84TiB
> {-snip-}
> devid 4 size 9.10TiB used 2.57TiB path /dev/sdu
> {-snip-}
>
> root@CENTAUR:~# btrfs fi usage -T /mnt/data
> Overall:
> Device size: 73.68TiB
> Device allocated: 41.73TiB
> Device unallocated: 31.95TiB
> Device missing: 0.00B
> Used: 41.69TiB
> Free (estimated): 15.99TiB (min: 15.99TiB)
> Data ratio: 2.00
> Metadata ratio: 2.00
> Global reserve: 512.00MiB (used: 0.00B)
>
> Data Metadata System
> Id Path RAID1 RAID1 RAID1 Unallocated
> -- -------- -------- -------- -------- -----------
> 4 /dev/sdu 2.57TiB 3.00GiB - 6.53TiB
> {-snip-}
>
> So everything is as I expect it to be afterwards- All ready to begin removing multiple drives.


I'm not really following this. An fs resize is implied by any device
add, remove or replace command. In the case of replace, it will
efficiently copy the device being replaced to the designated drive,
and then once that succeeds resize the file system to reflect the size
of the replacement device. I'm also confused why devid 4 seems to be
present before and after your device replace, so I have to wonder if
your copy paste really worked out as intended? And also, what version
of kernel and btrfs-progs are you using?

What do you mean by "usable space" and "available space"? It is
possibly confusing, the new and old tools intentional do things
differently, but it really depends on what you're referring to. I
suggest going to the faq and check out these two sections:
https://btrfs.wiki.kernel.org/index.php/FAQ
4.7.1 Understanding free space, using the original tools
4.7.2 Understanding free space, using the new tools

"unallocated" and "allocated" are specific terms that refer to block
groups (chunks). Space that's unallocated has no block groups, space
that's allocated is reserved for block groups; and inside each block
group there can be unused space. "Free space" is considered to be the
unused space in block groups  plus unallocated space.

btrfs filesystem show is confusing because "used" seems to be a term
used twice. The decoder ring is:
'fi show' "FS bytes used" as equal to 'fi usage' "Used"; and
'fi show' "devid ... used" as equal to 'fi usage' "Device allocated".

-- 
Chris Murphy
