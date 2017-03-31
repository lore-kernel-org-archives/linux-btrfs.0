Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54519 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753839AbdCaU2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 16:28:54 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:35578)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cu3AC-003zXi-1w
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 21:28:52 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cu393-0001jT-7E
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 21:27:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22750.48060.805852.28370@tree.ty.sabi.co.uk>
Date: Fri, 31 Mar 2017 21:27:40 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
        <22749.10893.729399.275210@tree.ty.sabi.co.uk>
        <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
        <22750.37100.788020.938846@tree.ty.sabi.co.uk>
        <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] what the signifigance of the xargs size limits of
> btrfs might be. [ ... ] So what does it mean that btrfs has a
> higher xargs size limit than other file systems? [ ... ] Or
> does the lower capacity for argument length for hfsplus
> demonstrate it is the superior file system for avoiding
> breakage? [ ... ]

That confuses, as my understanding of command argument size
limit is that it is a system, not filesystem, property, and for
example can be obtained with 'getconf _POSIX_ARG_MAX'.

> Personally, I would go back to fossil and venti on Plan 9 for
> an archival data server (using WORM drives),

In an ideal world we would be using Plan 9. Not necessarily with
Fossil and Venti. As a to storage/backup/archival Linux based
options are not bad, even if the platform is far messier than
Plan 9 (or some other alternatives). BTW I just noticed with a
search that AWS might be offering Plan 9 hosts :-).

> and VAX/VMS cluster for an HA server. [ ... ]

Uhmmm, however nice it was, it was fairly weird. An IA32 or
AMD64 port has been promised however :-).

https://www.theregister.co.uk/2016/10/13/openvms_moves_slowly_towards_x86/
