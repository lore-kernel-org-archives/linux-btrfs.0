Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3FQPQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 11:16:29 -0400
Date: Mon, 17 Jun 2013 17:16:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: converting lzo compression to zlib compression?
Message-ID: <20130617151626.GA5908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130617021653.4718a5e0@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130617021653.4718a5e0@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 17, 2013 at 02:16:53AM +0900, Tomasz Chmielewski wrote:
> I'd like to see how much space would I save by converting it to zlib.
> 
> Would it be possible to convert lzo compression to zlib compression
> with the following:
> 
> - mount the filesystem with "compress=zlib"

- run defrag on all desired files with -czlib

david
