Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35541 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbcJBU15 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Oct 2016 16:27:57 -0400
Received: by mail-oi0-f45.google.com with SMTP id w11so181659481oia.2
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 13:27:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161003012225.089c4d38@natsu>
References: <20161002181754.wxved3j66dzrvfoc@tiamat> <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
 <20161003012225.089c4d38@natsu>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 2 Oct 2016 14:27:56 -0600
Message-ID: <CAJCQCtRw+TMEDx9aPROdKSgbNDDw1PwkS2r8u-Lg_jyetv6wtQ@mail.gmail.com>
Subject: Re: Unable to open ctree
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 2, 2016 at 2:22 PM, Roman Mamedov <rm@romanrm.net> wrote:
> On Sun, 2 Oct 2016 13:29:56 -0600
> Chris Murphy <lists@colorremedies.com> wrote:
>
>> Well short of a bug, the problem aren't the checksums. The problem is
>> the metadata is wrong, so if you recalculate checksums you're likely
>> end up with an even more corrupted file system because it'll start out
>> trusting bad metadata.
>
> It appears that metadata got created with profile "single", because the device
> is SSD. If this was DUP metadata, this entire problem wouldn't happen.
> It is a terrible idea to downgrade metadata to single on detecting SSDs at
> mkfs.

That's uncertain, we've seen file systems with dup also not mount with
csum errors in metadata.



-- 
Chris Murphy
