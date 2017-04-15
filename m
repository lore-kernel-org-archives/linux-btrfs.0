Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36628 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdDOGO3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 02:14:29 -0400
Received: by mail-lf0-f52.google.com with SMTP id s141so48398701lfe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 23:14:28 -0700 (PDT)
Subject: Re: Btrfs disk layout question
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl>
 <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
 <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com>
 <ec5a00c8-5eb8-b7fa-c1e5-5eb72cb3512c@gmail.com>
 <8bc0e7b3-8df9-0def-de34-1a774d361f35@gmail.com>
 <CAJCQCtTJ-G9_18KSkt-YqL5y+ORRVXACfj80Azq579CSGzKacA@mail.gmail.com>
Cc: Adam Borowski <kilobyte@angband.pl>, Amin Hassani <ahassani@chromium.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <552552ec-6366-04f2-482f-d93d166081e1@gmail.com>
Date: Sat, 15 Apr 2017 09:14:25 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTJ-G9_18KSkt-YqL5y+ORRVXACfj80Azq579CSGzKacA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

12.04.2017 20:21, Chris Murphy пишет:
> btrfs-map-logical is the tool that will convert logical to physical
> and also give what device it's on; but the device notation is copy 1
> and copy 2, so you have to infer what device that is, it's not
> explicit.
> 

Actually I just checked with btrfsprogs 4.5.3 on RAID5 and it does print
OS device name for each data chunk. It does not show checksum chunk for
RAID56 though.
