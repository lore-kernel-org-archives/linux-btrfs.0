Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbbFKRJD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 13:09:03 -0400
Date: Thu, 11 Jun 2015 19:09:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is `mkfs.btrfs -r $rootdir` supposed to be used with?
Message-ID: <20150611170901.GG6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAGnHSEkjM2LVCvHgtpL6BKu8tabnZO5pcBaJQdf=B4P10UC3OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnHSEkjM2LVCvHgtpL6BKu8tabnZO5pcBaJQdf=B4P10UC3OQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 08:44:35PM +0800, Tom Yan wrote:
> I know `mkfs.btrfs -r $rootdir` copies whatever in $rootdir to the
> newly created filesystem.
> 
> When I try to use it for a block device, it creates a "minimal"
> filesystem which can only be mounted read-only.
> 
> When I use it for an (qemu raw) image, it seems to work but it also gives:
>  ERROR: device scan failed 'test.img' - Block device required
> in the process.
> 
> So what is it supposed to be used with?

That's a bug (will be fixed in btrfs-progs 4.1). The device scan ioctl
should not be called on a file. Otherwise it's harmless.
