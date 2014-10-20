Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaJTRIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 13:08:40 -0400
Date: Mon, 20 Oct 2014 19:08:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Suman Chakravartula <suman@rockstor.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Compressed size of a filesystem
Message-ID: <20141020170838.GY22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <911267269ecc4056ebe114fe78a52b0a@sonic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <911267269ecc4056ebe114fe78a52b0a@sonic.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 20, 2014 at 09:05:41AM -0700, Suman Chakravartula wrote:
> I'd like to calculate the compressed size of a btrfs filesystem. I read 
> the wiki and understand the backward compatibility issues mentioned. 
> Also, the "df before and after" method doesn't work for me and I have no 
> control over when end users are writing to the filesystem.
> 
> Wiki says there's a patch which is not merged. Is that refering to this 
> discussion:
> 
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/14942

I'll update the link.

> Why was the patch not merged?

Because the approach was abandoned in favor of a more generic solution
that reuses the existing interface (FIEMAP). The patchset implementing
this is

http://thread.gmane.org/gmane.comp.file-systems.btrfs/37312
