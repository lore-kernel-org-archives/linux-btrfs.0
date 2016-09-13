Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36906 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbcIML0h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 07:26:37 -0400
Received: by mail-it0-f46.google.com with SMTP id 186so36590393itf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 04:26:37 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: Timofey Titovets <nefelim4ag@gmail.com>, Waxhead <waxhead@online.no>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
 <6762481.5JxuKd9axT@merkaba> <20160912202109.GL28465@reaktio.net>
 <57D714A2.5040904@online.no>
 <CAGqmi768qya0JPv-UeEHDBiY=DWvLLdU84LJ8Wim5UHL8LETPQ@mail.gmail.com>
Cc: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>,
        Martin Steigerwald <martin@lichtvoll.de>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <643114c9-af90-622f-811f-817cc1d9db27@gmail.com>
Date: Tue, 13 Sep 2016 07:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAGqmi768qya0JPv-UeEHDBiY=DWvLLdU84LJ8Wim5UHL8LETPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-13 04:38, Timofey Titovets wrote:
> https://btrfs.wiki.kernel.org/index.php/Status
> I suggest to mark RAID1/10 as 'mostly ok'
> as on btrfs RAID1/10 is safe to data, but not for application that uses it.
> i.e. it not hide I/O error even if it's can be masked.
> https://www.spinics.net/lists/linux-btrfs/msg56739.html
>
> /* Retest it with upstream 4.7.2 - not fixed */
This doesn't match with what my own testing indicates at least for raid1 
mode.  I run similar tests myself every time a new stable kernel version 
comes out (but only on the most recent stable version) once I get my own 
patches re-based onto it, and I haven't seen issues like this in any of 
the 4.7 kernels, and don't recall any issues like this in any of the 4.6 
kernels.  In fact, I've actually dealt with systems with failing disks 
using BTRFS raid1 mode, including one at work just yesterday where the 
SATA cable had worked loose from vibrations and was causing significant 
data corruption.  It survived just fine, as have all the other systems 
I've dealt with which had hardware issues while running BTRFS in raid1 mode.

The indicated behavior would be consistent with issues seen sometimes 
when using compression however, but the OP in the linked message made no 
indication of there being any in-line compression involved.

