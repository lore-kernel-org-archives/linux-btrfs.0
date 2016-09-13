Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37342 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755796AbcIMIjV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 04:39:21 -0400
Received: by mail-wm0-f42.google.com with SMTP id c131so99404426wmh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 01:39:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57D714A2.5040904@online.no>
References: <57D51BF9.2010907@online.no> <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz> <6762481.5JxuKd9axT@merkaba>
 <20160912202109.GL28465@reaktio.net> <57D714A2.5040904@online.no>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 13 Sep 2016 11:38:39 +0300
Message-ID: <CAGqmi768qya0JPv-UeEHDBiY=DWvLLdU84LJ8Wim5UHL8LETPQ@mail.gmail.com>
Subject: Re: Is stability a joke? (wiki updated)
To: Waxhead <waxhead@online.no>
Cc: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>,
        Martin Steigerwald <martin@lichtvoll.de>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://btrfs.wiki.kernel.org/index.php/Status
I suggest to mark RAID1/10 as 'mostly ok'
as on btrfs RAID1/10 is safe to data, but not for application that uses it.
i.e. it not hide I/O error even if it's can be masked.
https://www.spinics.net/lists/linux-btrfs/msg56739.html

/* Retest it with upstream 4.7.2 - not fixed */


-- 
Have a nice day,
Timofey.
