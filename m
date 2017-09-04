Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.sws.net.au ([203.15.121.86]:53624 "EHLO smtp.sws.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753604AbdIDNi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 09:38:57 -0400
Received: from athena.localnet (ppp118-209-117-33.bras1.mel11.internode.on.net [118.209.117.33])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: russell@coker.com.au)
        by smtp.sws.net.au (Postfix) with ESMTPSA id 0BB39EFF6
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 23:38:59 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: Re: speed up big btrfs volumes with ssds
Date: Mon, 04 Sep 2017 23:38:54 +1000
Message-ID: <4162920.CfW0nAYGZq@russell.coker.com.au>
In-Reply-To: <e43a6dea-0e4c-50e4-da0d-03ac3ab9a97f@profihost.ag>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag> <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com> <e43a6dea-0e4c-50e4-da0d-03ac3ab9a97f@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 4 September 2017 2:57:18 PM AEST Stefan Priebe - Profihost AG 
wrote:
> > Then roughly make sure the complete set of metadata blocks fits in the
> > cache. For an fs of this size let's say/estimate 150G. Then maybe same
> > of double for data, so an SSD of 500G would be a first try.
> 
> I would use 1TB devices for each Raid or a 4TB PCIe card.

One thing I've considered is to create a filesystem with a RAID-1 of SSDs and 
then create lots of files with long names to use up a lot of space on the 
SSDs.  Then delete those files and add disks to the filesystem.  Then BTRFS 
should keep using the allocated metadata blocks on the SSD for all metadata 
and use disks for just data.

I haven't yet tried bcache, but would prefer something simpler with one less 
layer.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

