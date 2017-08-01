Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54694 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbdHAXyM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 19:54:12 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:40426)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dcgzK-0003U1-AB
        for linux-btrfs@vger.kernel.org; Wed, 02 Aug 2017 00:54:10 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dcgzI-00027D-A1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 00:54:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22913.5277.694308.689951@tree.ty.sabi.co.uk>
Date: Wed, 2 Aug 2017 00:54:05 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <22912.57311.417226.447973@tree.ty.sabi.co.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
        <22907.32175.311827.10738@tree.ty.sabi.co.uk>
        <19527869.26.1501422186960.JavaMail.gkos@dynomob>
        <22911.5971.350346.969146@tree.ty.sabi.co.uk>
        <6022267.255.1501581534233.JavaMail.gkos@dynomob>
        <22912.32415.601826.757780@tree.ty.sabi.co.uk>
        <15990599.40.1501611004053.JavaMail.gkos@dynomob>
        <22912.57311.417226.447973@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> This is the "storage for beginners" version, what happens in
> practice however depends a lot on specific workload profile
> (typical read/write size and latencies and rates), caching and
> queueing algorithms in both Linux and the HA firmware.

To add a bit of slightly more advanced discussion, the main
reason for larger strips ("chunk size) is to avoid the huge
latencies of disk rotation using unsynchronized disk drives, as
detailed here:

  http://www.sabi.co.uk/blog/12-thr.html?120310#120310

That relates weakly to Btrfs.
