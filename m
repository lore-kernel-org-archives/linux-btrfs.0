Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D0AC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3B0320869
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 23:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="gmR11Mc+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbeL0XiK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 18:38:10 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:34982 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbeL0XiK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 18:38:10 -0500
Received: by mail-lj1-f182.google.com with SMTP id x85-v6so17436974ljb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2018 15:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXOdJ2FH1NHrTiXjotIDrn628RE0I5jvrr1ZqkfV+6Y=;
        b=gmR11Mc+PAuHLg28i+afPNZO+d0yj3kSDBHinLb755StgYBeNs5Tn5Nv2uv9tFkqQY
         7zSJp2G3GQnf4ssltGZJhifm2Et/DKqPeuQZwmYNWRL1imSLYkPw73LgzGGKywKX2hWy
         GAvE5KAB2UdhdOBo/JuvQj0WF4331eBlUqPFUMmGs/Zw8DqYB6KPXsD9BG/QBjSKGix3
         BCWgvyhMEODNMveCiwtY/Uy9NFluKB1K+o2DzRaIkzaE8fJoQnHk8KuWojgTmGaDPD8T
         3G4sDJzZ38WEPrFhr8yrUtNMuLGgzS9dSe/7OHUSRYiasbhw6w53X7eoIYkXMk9sIwzX
         dbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXOdJ2FH1NHrTiXjotIDrn628RE0I5jvrr1ZqkfV+6Y=;
        b=LzUWlCUZXXWjuBI5hRui7XP/Dk/XYH4d1MTvkut/kC2Qw9AOmaun0b503g8ajUcfTT
         pulY0BJYL7AA+4/+DtGVBQcvj37g54TjYtaegRQ3PsJ3D0qYwtKXHjpLuAnJ7EIbRIty
         eynw+QFrXMtcBsRsMxYXe6eLF2P50xBhmsm5Qml0tInTabr9m4dJPw7YVU/lGE2ZLlMA
         AYWnyP21JUWQexlp7U5SwjyzsaNSdXKuGyvojq3GfHy3Q5kWnXsgF53y4ZU5KJ96UuAW
         yblI4NCUPpb6pMc3i4qJwhRVA6q1amawtmnnZzYo10fNXQHtZLLY9HCHvuC4rrUcuMtl
         V+0g==
X-Gm-Message-State: AA+aEWYYiEwYfnBBcgLIjNqvWmEi/mcCmQ/Aduhruz7S4x4uS8iTQbRh
        941Z/MohIgtfalp/YfqtwAl9WJ7sQwD2h4nIgrV5Hw==
X-Google-Smtp-Source: ALg8bN7O2labtYyzqlKUCQqBZ9ArpswB6OfljgvI/wp0DlhjpdrSdXvxplcl0juxVPIKsUzsV4RiMLk1Q1aqkRSrtrw=
X-Received: by 2002:a2e:880a:: with SMTP id x10-v6mr15964525ljh.174.1545953887312;
 Thu, 27 Dec 2018 15:38:07 -0800 (PST)
MIME-Version: 1.0
References: <96d61222666591a99b9b9f0c42bf4d5f@mailmag.net> <CAJCQCtS7XJaD4Mhrg152K4zfj-w2P0JkpUvZ0R-M6x8QmCc1tg@mail.gmail.com>
 <pan$ac19$67da17d$80a83557$ce46be42@cox.net> <ffec4fbe6b91b88e1f7bd57ccb568310@mailmag.net>
In-Reply-To: <ffec4fbe6b91b88e1f7bd57ccb568310@mailmag.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 27 Dec 2018 16:37:55 -0700
Message-ID: <CAJCQCtRFwLvPFkjhXfs+UFmOu+rHAQ-Zq3Mk6T_q22Qn0zgc7A@mail.gmail.com>
Subject: Re: btrfs fi usage -T shows unallocated column as total in drive, not
 total available to btrfs
To:     Joshua Villwock <joshua@mailmag.net>
Cc:     Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 27, 2018 at 1:33 PM <joshua@mailmag.net> wrote:
>


> Perhaps my original assumptions were incorrect, but I had originally assumed that since both the
> commands I ran were 'btrfs fi' commands, that they would be reporting on the same things, just in
> different formats. (btrfs fi show & btrfs fi usage)
> I also assumed, (perhaps incorrectly) that since they were "filesystem" commands, (btrfs fi) they
> would be reporting on the amounts directly available to btrfs.



>
> Regardless, after running replace, but before running resize, 'btrfs fi show' reported the
> following:
> devid 4 size 2.73TiB used 2.57TiB path /dev/sdu

devid size should match super block dev_item.total_bytes, and devid
used should match super block dev_item.bytes_used

dev_item.total_bytes normally matches the bytes for the block device
in question; but due to resize it might not match.


> However, 'btrfs fi usage -T /mnt/data' reported the following:
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
> -- -------- -------- -------- -------- -----------
> Total 20.84TiB 31.00GiB 32.00MiB 31.95TiB
> Used 20.82TiB 29.60GiB 2.98MiB
>
> Of particular interest here is that the data in the header (Overall) is no different than before
> the replace, so it is fully aware the space is not (yet) usable, and thus reporting it correctly.
> Just the Unallocated column is potentially misleading (and the totals at the bottom)

OK let me see if I get this right. You're saying it's confusing that
'btrfs fi sh' "devid size" does not change when doing a device
replace; whereas 'btrfs fi us' device specific "unallocated" does
change, even though you haven't yet done a resize.

I kinda sorta agree. While "unallocated" becomes 6.53TiB for this
device, the idea it's unallocated suggests it could be allocated,
which before a resize it cannot be allocated.

Someone would have to dig into the btrfs-progs code and see how
"unallocated" is computed per device, maybe there's a rationalization
in the comments. I'd say it's confusing if unallocated for a device is
greater than either 'btrfs fi sh' "devid size" or dev_item.total_bytes
found in the super for that device.


> I should note that every device in this particular Array/Pool is not using partitions; I'm using
> btrfs directly on the device. Perhaps this is why btrfs is handling it this way?  I wonder how it
> behaves on a partitioned FileSystem.

It behaves the same. Whether partitioned or not, Btrfs sees it as a
block device.


-- 
Chris Murphy
