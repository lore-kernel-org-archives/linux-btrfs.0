Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:33964 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbdDLRVP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 13:21:15 -0400
Received: by mail-yb0-f173.google.com with SMTP id m133so8205689ybb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Apr 2017 10:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8bc0e7b3-8df9-0def-de34-1a774d361f35@gmail.com>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl> <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
 <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com> <ec5a00c8-5eb8-b7fa-c1e5-5eb72cb3512c@gmail.com>
 <8bc0e7b3-8df9-0def-de34-1a774d361f35@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 12 Apr 2017 11:21:14 -0600
Message-ID: <CAJCQCtTJ-G9_18KSkt-YqL5y+ORRVXACfj80Azq579CSGzKacA@mail.gmail.com>
Subject: Re: Btrfs disk layout question
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Amin Hassani <ahassani@chromium.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-map-logical is the tool that will convert logical to physical
and also give what device it's on; but the device notation is copy 1
and copy 2, so you have to infer what device that is, it's not
explicit.


Chris Murphy
