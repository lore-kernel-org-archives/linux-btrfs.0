Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35091 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbcEIVaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 17:30:46 -0400
Received: by mail-oi0-f66.google.com with SMTP id w198so28360158oiw.2
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 14:30:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
	<CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
	<c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
	<20160505174854.GA1012@vader.dhcp.thefacebook.com>
	<585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
	<2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
	<CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
	<f1dd07efb34a0a110f62566979530944@linuxsystems.it>
	<799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
	<52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
Date: Mon, 9 May 2016 15:30:45 -0600
Message-ID: <CAJCQCtSbLVuvnyLFM7mj=Kx=mC1X1n4azRyo1pFVv3VBzJephA@mail.gmail.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Clemens Eisserer <linuxhippy@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 9, 2016 at 8:53 AM, Niccolò Belli <darkbasic@linuxsystems.it> wrote:

> I cannot manage to survive such annoying workflow for long, so I really hope
> someone will manage to track the bug down soon.

I suggest perseverance :) despite how tedious this is. Btrfs is more
aware of its state than other file systems, so if you give up and go
to ext4 it's entirely possible corruption is still happening but you
won't know it until there's a lot more damage. At the least if you
have to give up I'd suggest XFS and make sure you're using not older
than xfsprogs 3.2.3 which will make a V5 file system that uses
metadata checksumming by default.


-- 
Chris Murphy
