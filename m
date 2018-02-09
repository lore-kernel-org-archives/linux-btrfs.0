Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:48722 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeBISZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Feb 2018 13:25:04 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:43198)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89_1)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1ekCC3-0006ya-EG
        for linux-btrfs@vger.kernel.org; Fri, 09 Feb 2018 17:10:35 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ekCBx-0002EB-Hl
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Feb 2018 17:10:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23165.54788.765684.62484@tree.ty.sabi.co.uk>
Date: Fri, 9 Feb 2018 17:10:28 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-cleaner / snapshot performance analysis
In-Reply-To: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I am trying to better understand how the cleaner kthread
> (btrfs-cleaner) impacts foreground performance, specifically
> during snapshot deletion.  My experience so far has been that
> it can be dramatically disruptive to foreground I/O.

That's such a warmly innocent and optimistic question! This post
gives the answer, and to an even more general question:

  http://www.sabi.co.uk/blog/17-one.html?170610#170610

> the response tends to be "use less snapshots," or "disable
> quotas," both of which strike me as intellectually
> unsatisfying answers, especially the former in a filesystem
> where snapshots are supposed to be "first-class citizens."

They are "first class" but not "cost-free".
In particular every extent is linked in a forward map and a
reverse map, and deleting a snapshot involves materializing and
updating a join of the two, which seems to be done with a
classic nested-loop join strategy resulting in N^2 running
time. I suspect that quotas have a similar optimization.
