Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbbENOGU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 10:06:20 -0400
Date: Thu, 14 May 2015 16:06:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Luke Dashjr <luke@dashjr.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20150514140617.GY23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201505131715.27483.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201505131715.27483.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 05:15:26PM +0000, Luke Dashjr wrote:
> 32-bit ioctl uses these rather than the regular FS_IOC_* versions. They can be 
> handled in btrfs using the same code. Without this, 32-bit {ch,ls}attr fail.

Yes, but this has to be implemented in another way. See eg.
https://git.kernel.org/linus/e9750824114ff
