Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40491 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbdIDAOm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Sep 2017 20:14:42 -0400
Date: Mon, 4 Sep 2017 02:14:40 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
Subject: Re: How to disable/revoke 'compression'?
Message-ID: <20170904001440.il6kmsl2cioklcie@angband.pl>
References: <1504459921.8809.3.camel@cloud.haefemeier.eu>
 <20170903180636.ayrubvma7awbki6i@angband.pl>
 <5e49c33f-ce4b-523d-24e6-befd379503a9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5e49c33f-ce4b-523d-24e6-befd379503a9@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 07:55:27AM +0800, Qu Wenruo wrote:
> On 2017年09月04日 02:06, Adam Borowski wrote:
> > I've once written a tool which does this, but 1. it's extremely slow, 2.
> > insane, 3. so insane a certain member of this list would kill me had I
> > distributed the tool.  Thus, I'd need to rewrite it first...
> 
> AFAIK the only method to determine the compression ratio is to check the
> EXTENT_DATA key and its corresponding file_extent_item structure.
> (Which I assume Adam is doing this way)
> 
> In that structure is records its on-disk data size and in-memory data size.
> (All rounded up to sectorsize, which is 4K in most case)
> So in theory it's possible to determine the compression ratio.
> 
> The only method I can think of (maybe I forgot some methods?) is to use
> offline tool (btrfs-debug-tree) to check that.
> FS APIs like fiemap doesn't even support to report on-disk data size so we
> can't use it.

BTRFS_IOC_TREE_SEARCH_V2 returns all we want to know; its only downside is
being root only.

> But the problem is more complicated, especially when compressed CoW is
> involved.
> 
> For example, there is an extent (A) which represents the data for inode 258,
> range [0,128k).
> On disk size its just 4K.
> 
> And when we write the range [32K, 64K), which get CoWed and compressed,
> resulting a new file extent (B) for inode 258, range [32K, 64K), and on disk
> size is 4K as an example.
> 
> Then file extent layout for 258 will be:
> [0,32k):  range [0,32K) of uncompressed Extent A
> [32k, 64k): range [0,32k) of uncompressed Extent B
> [64k, 128k): range [64k, 128K) of uncompressed Extent A.
> 
> And on disk extent size is 4K (compressed Extent A) + 4K (compressed Extent
> B) = 8K.
> 
> Before the write, the compresstion ratio is 4K/128K = 3.125%
> While after write, the compression ratio is 8K/128K = 6.25%

There's no real meaningful way to speak about compression ratio of a partial
extent.  Thus, I decided to, for every extent, take compressed:uncompressed
sizes of the whole extent, no matter whether the file uses only a few bytes
of that extent or references it a thousand times.

> Not to mention that it's possible to have uncompressed file extent.

Yeah, the tool gives a report like:
all   74%  9.2M/  13M
lzo   68%  7.1M/  11M
none 100%  2.1M/ 2.1M
as you typically have a mix of compressible and uncompressible data.


喵!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ Vat kind uf sufficiently advanced technology iz dis!?
⢿⡄⠘⠷⠚⠋⠀                                 -- Genghis Ht'rok'din
⠈⠳⣄⠀⠀⠀⠀ 
