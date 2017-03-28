Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:44506 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752588AbdC1PAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 11:00:46 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:42846)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.for.sabi.co.uk>)
        id 1cssbH-002So1-8L
        for linux-btrfs@vger.kernel.org; Tue, 28 Mar 2017 15:59:59 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cssbB-0007zC-2i
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 15:59:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <22746.31336.732079.373753@tree.ty.sabi.co.uk>
Date: Tue, 28 Mar 2017 15:59:52 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <22746.30348.324000.636753@tree.ty.sabi.co.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
From: pg@btrfs.for.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] reminded of all the cases where someone left me to
> decatastrophize a storage system built on "optimistic"
> assumptions.

In particular when some "clever" sysadm with a "clever" (or
dumb) manager slaps together a large storage system in the
cheapest and quickest way knowing that while it is mostly empty
it will seem very fast regardless and therefore to have awesome
performance, and then the "clever" sysadm disappears surrounded
by a halo of glory before the storage system gets full workload
and fills up; when that happens usually I get to inherit it.
BTW The same technique also can be done with HPC clusters.

>> I intended to shrink a ~22TiB filesystem down to 20TiB. This
>> is still using LVM underneath so that I can’t just remove a
>> device from the filesystem but have to use the resize
>> command.

>> Label: 'backy'  uuid: 3d0b7511-4901-4554-96d4-e6f9627ea9a4
>> Total devices 1 FS bytes used 18.21TiB
>> devid    1 size 20.00TiB used 20.71TiB path /dev/mapper/vgsys-backy

Ahh it is indeed a filled up storage system now running a full
workload. At least it wasn't me who inherited it this time. :-)
