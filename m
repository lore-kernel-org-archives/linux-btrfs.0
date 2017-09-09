Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:42934 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753476AbdIIKsr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 06:48:47 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 0A78526AF
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 12:48:46 +0200 (MEST)
Date: Sat, 9 Sep 2017 12:48:45 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: generic name for volume and subvolume root?
Message-ID: <20170909104845.GW12642@rus.uni-stuttgart.de>
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
 <48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-09 (18:40), Qu Wenruo wrote:

> > Is there a generic name for both volume and subvolume root?
> 
> Nope, subvolume (including snapshot) is not distinguished by its 
> filename/path/directory name.
> 
> And you can only do snapshot on subvolume (snapshot is one kind of 
> subvolume) boundary.

So, I can name a btrfs root volume also btrfs subvolume?

I am talking about documentation, not coding!

I just want yo use the correct terms.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
