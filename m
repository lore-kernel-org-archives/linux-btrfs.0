Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbcHPNdy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 09:33:54 -0400
Date: Tue, 16 Aug 2016 15:33:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Determine the creation time of a root tree
Message-ID: <20160816133300.GM30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMG9ccwBF4x+f_y3QFqsYnjDFX=CwQm5ktqpLD5EbQm4jdfQzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMG9ccwBF4x+f_y3QFqsYnjDFX=CwQm5ktqpLD5EbQm4jdfQzg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 06, 2016 at 06:11:58PM +0300, Ivan Sizov wrote:
> Is there a way to know when the root tree or generation was created?
> btrfs-find-root doesn't have such option.

The 'otime' is set and stored witin the inode item that represents the
subvolume. At the moment there's no direct way to read the otime for
topelvel subvolume, otherwise it's available via
'btrfs subvolume show /path/subvolume'
