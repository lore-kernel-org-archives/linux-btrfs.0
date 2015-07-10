Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbbGJNBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 09:01:31 -0400
Date: Fri, 10 Jul 2015 15:01:29 +0200
From: David Sterba <dsterba@suse.cz>
To: james harvey <jamespharvey20@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Message-ID: <20150710130129.GH726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 08, 2015 at 09:20:46PM -0400, james harvey wrote:
> Would (I think):
> * btrfs subvolume create <dest-subvolume>
> * cp -ax --reflink=always <source-subvolume>/* <dest-subvolume>/
> 
> Particularly useful to avoid "Invalid cross-device link" when using cp
> -ax, when source and dest are seen as different devices.
> 
> Such as if there is a top-level subvolume mounted as /, with others
> mounted elsewhere.  Required workaround is to mount with subvolid=0 to
> /mnt, cp -ax --reflink=always /mnt/...source /mnt/...dest

This is a known limitation of reflinks and intentional, ie. no
cross-mountpoint operations are allowed to a single filesystem. The same
holds for hardlinks and the reflink duplicates the restrictions.
