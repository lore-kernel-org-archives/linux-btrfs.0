Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42539 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2LUSto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 13:49:44 -0500
Received: by mail-ee0-f54.google.com with SMTP id c13so2542658eek.27
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2012 10:49:43 -0800 (PST)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: add, remove; how about merge?
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
In-Reply-To: <50D4A79B.6010008@czarc.net>
Date: Fri, 21 Dec 2012 19:18:04 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <08354545-7E01-4EB2-AF90-D1CF900C69E2@yerf-it.nl>
References: <50D4A79B.6010008@czarc.net>
To: Gene Czarcinski <gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think thats possible with btrfs-send/receive

Remco

On Dec 21, 2012, at 7:16 PM, Gene Czarcinski <gene@czarc.net> wrote:

> I am new at this btrfs stuff!
> 
> As I understand it, you can add a physical disk or partition and have data spread into the new space.  You can also move data off a disk or partition and then remove it.
> 
> Has any though  been given to being able merge to existing (separate) btrfs "volumes" into a single volume?
> 
> Alternatively, how about at tool for transfering a subvolume from one pool to another?  I tried using fsarchiver but that did not work out too well.
> 
> Gene
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

