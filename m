Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f170.google.com ([209.85.210.170]:35915 "EHLO
        mail-wj0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbcL3JeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Dec 2016 04:34:03 -0500
Received: by mail-wj0-f170.google.com with SMTP id c11so169700568wjx.3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Dec 2016 01:34:02 -0800 (PST)
Subject: Re: Incremental send receive of snapshot fails
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: Rene Wolf <igeligel@gmx.net>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <274dac29-62b2-b366-8bbc-b2c55773c113@gmx.net>
References: <1483025509.3496.34.camel@localhost>
         <274dac29-62b2-b366-8bbc-b2c55773c113@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Dec 2016 10:34:24 +0100
Message-ID: <1483090464.3499.10.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

If btrfs check does not display error messages, the filesystem is ok.

I do not have enough knowledge to analyze your data.

But if you're sure that all filesystems do not have problems, the
problem is the parent subvolume in the receiving filesystem.


Regards.

Gdb


Rene Wolf:
> Hi
> 
> 
> As the fs in question is my root, I tried the following using a live usb 
> stick of a xubuntu 16.10:
> 
> > Checking filesystem on /dev/sdb1
> > UUID: 122ecca7-9804-4c8a-b4ed-42fd6c6bbe7a
> > checking extents [o]
> > checking free space cache [.]
> > checking fs roots [o]
> > found 40577679360 bytes used err is 0
> > total csum bytes: 39027548
> > total tree bytes: 571277312
> > total fs tree bytes: 453001216
> > total extent tree bytes: 71745536
> > btree space waste bytes: 116244847
> > file data blocks allocated: 46952968192
> >  referenced 44081487872
> 
> "err is 0" ... so I guess that means everything is fine?
> 
]zac[

