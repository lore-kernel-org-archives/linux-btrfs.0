Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:53361 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755805AbdEDOWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 May 2017 10:22:35 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:44196)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d6HeK-000gOP-V4
        for linux-btrfs@vger.kernel.org; Thu, 04 May 2017 15:22:33 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d6HeF-0003GL-AZ
        for <linux-btrfs@vger.kernel.org>; Thu, 04 May 2017 15:22:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22795.14626.978819.534566@tree.ty.sabi.co.uk>
Date: Thu, 4 May 2017 15:22:26 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Struggling with file system slowness
In-Reply-To: <a5052685-e126-d11d-7e9c-fc010c958319@techsquare.com>
References: <a5052685-e126-d11d-7e9c-fc010c958319@techsquare.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Trying to peg down why I have one server that has
> btrfs-transacti pegged at 100% CPU for most of the time.

Too little information. Is IO happening at the same time? Is
compression on? Deduplicated? Lots of subvolumes? SSD? What kind
of workload and file size/distribution profile?

Typical high CPU are extents (your defragging not necessarily
worked), and 'qgroups', especially with many subvolumes. It
could be the fre space cache in some rare cases.

  https://www.google.ca/search?num=100&safe=images&as_q=cxpu&as_epq=btrfs-transaction

To this something like this happens often, but is not
Btrfs-related, but triggered for example by near-memory
exhaustion in the kernel memory manager.
