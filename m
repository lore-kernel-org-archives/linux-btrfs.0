Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35423 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcFDTNm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 15:13:42 -0400
Received: by mail-oi0-f48.google.com with SMTP id w184so173541080oiw.2
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 12:13:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465061839.6689.9.camel@scientia.net>
References: <1464819934.6742.71.camel@scientia.net>
	<d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
	<1464975482.6679.11.camel@scientia.net>
	<6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
	<1465005092.6648.39.camel@scientia.net>
	<57528238.6080809@gmail.com>
	<CAJCQCtS+GK88LZHY-uoWarn0qCuDuva4rg_TB_jEwAZo3nCcDQ@mail.gmail.com>
	<1465061839.6689.9.camel@scientia.net>
Date: Sat, 4 Jun 2016 13:13:40 -0600
Message-ID: <CAJCQCtQsfC5U2dSiT-tdPseaHmJPf=9fai+2vGUNxuf8veKx7g@mail.gmail.com>
Subject: Re: btrfs
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 4, 2016 at 11:37 AM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sat, 2016-06-04 at 11:00 -0600, Chris Murphy wrote:
>> SNIA's DDF 2.0 spec Rev 19
>> page 18/19 shows 'RAID-1 Simple Mirroring" vs "RAID-1 Multi-
>> Mirroring"
>
> And DDF came how many years after the original RAID paper and everyone
> understood RAID1 as it was defined there? 1987 vs. ~2003 or so?
>
> Also SINA's "standard definition" seems pretty strange, doesn't it?
> They have two RAID1, as you say:
> - "simple mirroring" with n=2
> - "multi mirrioring" with n=3
>
> I wouldn't see why the n=2 case is "simpler" than the n=3 case, neither
> why the n=3 case is multi and the n=2 is not (it's also already
> multiple disks).
> Also why did they allow n=3 but not n>=3? If n=4 wouldn't make sense,
> why would n=3, compared to n=2?
>
> Anyway,...
> - the original paper defines it as n mirrored disks
> - Wikipedia handles it like that
> - the already existing major RAID implementation (MD) in the Linux
>   kernel handles it like that
> - LVM's native mirroring, allows to set the number of mirrors, i.e. it
>   allows for everything >=2 which is IMHO closer to the common meaning
>   of RAID1 than to btrfs' two-duplicates
>
> So even if there would be some reasonable competing definition (and I
> don't think the rather proprietary DDF is very reasonable here), why
> using one that is incomptabible with everything we have in Linux?

mdadm supports DDF.


-- 
Chris Murphy
