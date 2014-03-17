Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171AbaCQOz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 10:55:56 -0400
Date: Mon, 17 Mar 2014 15:55:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [PATCH 0/6 EARLY RFC] Btrfs: Get rid of whole page I/O.
Message-ID: <20140317145555.GG29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 12, 2014 at 07:50:27PM +0530, Chandan Rajendra wrote:
> The patchset has been tested with only a handful of trivial I/O tests i.e. I/O
> on different kinds of files (e.g. files with holes, etc). The tests were run
> on 2k and 4k blocksized instances of Btrfs code (on x86_64) that has initial
> support for mounting a 2k blocksized Btrfs filesystem.

> 3. Compression does not work with 2k blocksize filesystem instance.

I looked at previous postings of this patchset, but haven't found what
are the expected supported block sizes.

I assume powers of two starting with 512b, until 64k.

I'm asking because the compression container would need to take this
into account. (I originally had only >= 4k sizes in mind.)


thanks,
david
