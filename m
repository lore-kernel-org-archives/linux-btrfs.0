Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34292 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbcEBWFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 18:05:51 -0400
Received: by mail-pf0-f170.google.com with SMTP id y69so833176pfb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 15:05:51 -0700 (PDT)
Date: Mon, 2 May 2016 15:05:49 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs goes readonly + No space left on 4.3
Message-ID: <20160502220549.GB24432@vader.DHCP.thefacebook.com>
References: <561B5AA6.7040704@profihost.ag>
 <5723C88F.30903@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5723C88F.30903@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 10:48:15PM +0200, Stefan Priebe wrote:
> just want to drop a note that all those ENOSPC msg are gone with v4.5 and
> space_cache=v2. Any plans to make space_cache=v2 default?
> 
> Greets,
> Stefan

Yup, we want to make space_cache=v2 the default at some point. I'm
running it on my own machines and testing it here at Facebook and
haven't run into any issues yet. Besides stability, I also want to make
sure there aren't any performance regressions versus the old free space
cache that we haven't thought about yet.

Thanks for trying it out :)

-- 
Omar
