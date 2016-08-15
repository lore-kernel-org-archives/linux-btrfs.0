Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:34464 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbcHOTST (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 15:18:19 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 7EE3C9B976
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 20:18:15 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 57AE35FBA1
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 20:18:15 +0100 (BST)
Subject: Re: Extents for a particular subvolume
To: linux-btrfs@vger.kernel.org
References: <57A24C51.2050302@cobb.uk.net> <20160803203708.GA26505@angband.pl>
 <57A26867.5020403@cobb.uk.net>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <77c778fa-5495-23dc-5482-297e23f58c81@cobb.uk.net>
Date: Mon, 15 Aug 2016 20:18:15 +0100
MIME-Version: 1.0
In-Reply-To: <57A26867.5020403@cobb.uk.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/08/16 22:55, Graham Cobb wrote:
> On 03/08/16 21:37, Adam Borowski wrote:
>> On Wed, Aug 03, 2016 at 08:56:01PM +0100, Graham Cobb wrote:
>>> Are there any btrfs commands (or APIs) to allow a script to create a
>>> list of all the extents referred to within a particular (mounted)
>>> subvolume?  And is it a reasonably efficient process (i.e. doesn't
>>> involve backrefs and, preferably, doesn't involve following directory
>>> trees)?

In case anyone else is interested in this, I ended up creating some
simple scripts to allow me to do this.  They are slow because they walk
the directory tree and they use filefrag to get the extent data, but
they do let me answer questions like:

* How much space am I wasting by keeping historical snapshots?
* How much data is being shared between two subvolumes
* How much of the data in my latest snapshot is unique to that snapshot?
* How much data would I actually free up if I removed (just) these
particular subvolumes?

If they are useful to anyone else you can find them at:

https://github.com/GrahamCobb/extents-lists

If anyone knows of more efficient ways to get this information please
let me know. And, of course, feel free to suggest improvements/bugfixes!


