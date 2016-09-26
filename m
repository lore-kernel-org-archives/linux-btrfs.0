Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:37492 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034972AbcIZU4n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 16:56:43 -0400
Date: Mon, 26 Sep 2016 16:56:39 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Ruben Salzgeber <ruben.salzgeber@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: OS X Time Machine and BTRFS
Message-ID: <20160926205639.GB4624@coach.home>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2016 at 10:15:11PM +0200, Ruben Salzgeber wrote:
> Hi everyone
> 
> I'm reaching out to you because I experience unusually slow read and
> write speeds on my Arch Linux server in combination with OS X time
> machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
> for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
> version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
> connection I reach 120MB/s for normal filetransfers from OS X to the
> Server. When using Time Machine I measure peak network trafic around
> 1-2MB/s and long durations of almost no trafic. Could this be in any
> relation to BTRFS? Is there a special configuration necessary for
> folders containing the Time Machine sparsebundle file?

Have you done any inspection with tools like [h]top, iotop, etc.?
Identifying the bottleneck is usually pretty straightforward with those,
and it's nice to try and dismiss things like cpu bottlenecks before
going to more advanced diagnostics.

--Sean

