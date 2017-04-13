Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33047 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755528AbdDMD0p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 23:26:45 -0400
Received: by mail-lf0-f48.google.com with SMTP id h125so23381026lfe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 20:26:44 -0700 (PDT)
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
Message-ID: <47670e6f-e895-709f-efe3-9548843acd2e@gmail.com>
Date: Thu, 13 Apr 2017 06:26:42 +0300
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

Quickly checking output - for my purposes it looks OK, as BIS just tries
to warn if file is too far to be accessible by BIOS, so I am not even
interested in specific device, just max physical offset. Thank you!
