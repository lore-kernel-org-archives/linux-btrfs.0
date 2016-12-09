Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59288 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbcLIQIA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 11:08:00 -0500
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <CAJCQCtS8zCMYYiedYpkL4bZE0PvEF+sLGG96Uq=Ms1qjd4uCpg@mail.gmail.com>
 <2d4f5ee2-fc2b-ac48-8f4b-eecf8936b9e1@petaramesh.org>
 <CAJCQCtRgFp6aMRBR8K6PKknGCyC6cxm80tG5xRq8O5hS31pzhA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <584AD6DE.3080500@applied-asynchrony.com>
Date: Fri, 9 Dec 2016 17:07:58 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRgFp6aMRBR8K6PKknGCyC6cxm80tG5xRq8O5hS31pzhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/16 16:43, Chris Murphy wrote:
>> If compression has nothing to do with this, then this is heavy
>> fragmentation.
> 
> It's probably not that fragmented. Due to compression, metadata
> describes 128KiB extents even though the data is actually contiguous.
> 
> And it might be the same thing in my case also, even though no
> compression is involved.

In that case you can quickly collapse physically contiguous ranges by
reflink-mv'ing (ie. a recent mv) the file across subvolume boundaries
and back. :)

-h

