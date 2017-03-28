Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:44585 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753842AbdC1PUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 11:20:34 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:42870)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cssuv-002Tfx-Af
        for linux-btrfs@vger.kernel.org; Tue, 28 Mar 2017 16:20:17 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cssul-00087W-Fs
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Mar 2017 16:20:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22746.32551.139358.604932@tree.ty.sabi.co.uk>
Date: Tue, 28 Mar 2017 16:20:07 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <22746.31336.732079.373753@tree.ty.sabi.co.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <22746.31336.732079.373753@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  [ ... ] slaps together a large storage system in the cheapest
> and quickest way knowing that while it is mostly empty it will
> seem very fast regardless and therefore to have awesome
> performance, and then the "clever" sysadm disappears surrounded
> by a halo of glory before the storage system gets full workload
> and fills up; [ ... ]

Fortunately or unfortunately Btrfs is particularly suitable for
this technique, as it has an enormous number of checkbox-ticking
awesome looking feature: transparent compression, dynamic
add/remove, online balance/scrub, different sized member devices,
online grow/shrink, online defrag, limitless scalability, online
dedup, arbitrary subvolumes and snapshots, COW and reflinking,
online conversion of RAID profiles, ... and one can use all of
them at the same time, and for the initial period where volume
workload is low and space used not much, it will looks absolutely
fantastic, cheap, flexible, always available, fast, the work of
genius of a very cool sysadm.
