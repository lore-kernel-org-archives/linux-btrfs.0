Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60003 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761908Ab3DBRUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 13:20:18 -0400
Received: by mail-lb0-f176.google.com with SMTP id y8so723209lbh.35
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 10:20:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <515B120F.6000004@petaramesh.org>
References: <515A95C7.5090607@petaramesh.org> <20130402230421.016afe58@natsu> <515B120F.6000004@petaramesh.org>
From: Harald Glatt <mail@hachre.de>
Date: Tue, 2 Apr 2013 19:19:55 +0200
Message-ID: <CAFWF=ambfwg=mwhG+aEr+bKO1zwmjzJEYq3TeBUy=MxYZsbB9g@mail.gmail.com>
Subject: Re: Moving...
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Cc: Roman Mamedov <rm@romanrm.ru>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        zfs-discuss@zfsonlinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 2, 2013 at 7:14 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Le 02/04/2013 19:04, Roman Mamedov a écrit :
>> but at this point I trust my data to BTRFS more, than I would trust ZFS.
>
> My experience with ZFS on Linux is still somewhat limited, the only
> thing that I can say is that I've used it for about 2 years and a half
> on my (quite loaded) home server without ever encoutering a single issue
> (besides some tricky Ubuntu version upgrades, only due to the fact that
> ZFS is "not in the standard kernel" by opposition to BTRFS).
>
> On the BTRFS side, I've used it on 5 machine for about a year on a daily
> basis ; I've completely lost a filesystem, beyond repair, twice ; I
> found myself with a machine that wouldn't boot anymore and would
> necessitate serious and tricky FS maintenance, 3 times, I had to
> completely reinstall the FS because of extremely degraded performance, 4
> times.
>
> Add to this that the FS management tools and properly working FS
> features are an order of magnitude better in ZFS than in BTRFS...
>
> That's enough for me...
>
> I've already converted 2 machines from BTRFS to ZFS since yesterday.
>
> My netbook (now ZFS) boots to GDM in less than 30 seconds. My son's same
> machine (except for the FS) takes 75 MORE seconds.
>
> You get it.
>
> Kind regards.
>
> --
> Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I don't find it too suprising that you have more problems with a
filesystem that is not final than with one that has seen several years
of post-final improvements. I would be shocked if ZFS were in worse
shape than btrfs right now.
