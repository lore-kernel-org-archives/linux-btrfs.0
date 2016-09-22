Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33912 "EHLO
        mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034418AbcIVRuR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 13:50:17 -0400
Received: by mail-pa0-f47.google.com with SMTP id wk8so31392494pab.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 10:50:16 -0700 (PDT)
Date: Thu, 22 Sep 2016 10:50:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: ojab <ojab@ojab.ru>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>, dsterba@suse.cz,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, osandov@fb.com
Subject: Re: Status of free-space-tree feature
Message-ID: <20160922175014.GC4705@vader.DHCP.thefacebook.com>
References: <20160921092406.GD16983@twin.jikos.cz>
 <57E2602C.7050703@applied-asynchrony.com>
 <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
 <20160921203152.GA7694@vader.DHCP.thefacebook.com>
 <20160922085205.GM16983@suse.cz>
 <058a4346-16f5-850e-2974-d783a132547b@mendix.com>
 <20160922172651.GB4705@vader.DHCP.thefacebook.com>
 <45b54ff1-f226-3994-441c-22003f9dfb95@ojab.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45b54ff1-f226-3994-441c-22003f9dfb95@ojab.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:47:59PM +0000, ojab wrote:
> On 2016/09/22 17:26, Omar Sandoval wrote:
> > As far as I know, space_cache=v2 isn't documented in the man page, so
> > hopefully anyone who managed to find out about it follows the mailing
> > list. If someone updates their kernel without updating btrfs-progs, the
> > new compat_ro bit will prevent the old version from doing any damage.
> 
> Actually it's documented in `man 5 btrfs`.
> 
> //wbr ojab

Ah, thanks. I'll be sure to update that page when I send the btrfs-progs
patch.

-- 
Omar
