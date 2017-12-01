Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:45307 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdLARNz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 12:13:55 -0500
Received: by mail-lf0-f49.google.com with SMTP id f13so12439216lff.12
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Dec 2017 09:13:54 -0800 (PST)
Subject: Re: btrfs-transacti hammering the system
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <09218217-6c17-80df-380a-6c20366c70f3@gmail.com>
Date: Fri, 1 Dec 2017 20:13:52 +0300
MIME-Version: 1.0
In-Reply-To: <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

01.12.2017 20:06, Hans van Kranenburg пишет:
> 
> Additional tips (forgot to ask for your /proc/mounts before):
> * Use the noatime mount option, so that only accessing files does not
> lead to changes in metadata,

Is not 'lazytime" default today? It gives you correct atime + no extra
metadata update cause by update of atime only.
