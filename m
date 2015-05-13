Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60822 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934462AbbEMRiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 13:38:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 0520B20A5C
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2015 13:38:20 -0400 (EDT)
Date: Wed, 13 May 2015 10:38:17 -0700
From: Greg KH <greg@kroah.com>
To: Luke Dashjr <luke@dashjr.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20150513173817.GA19525@kroah.com>
References: <201505131715.27483.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201505131715.27483.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 05:15:26PM +0000, Luke Dashjr wrote:
> 32-bit ioctl uses these rather than the regular FS_IOC_* versions. They can be 
> handled in btrfs using the same code. Without this, 32-bit {ch,ls}attr fail.
> 
> Signed-off-by: Luke Dashjr <luke-jr+git@utopios.org>
> ---
>  fs/btrfs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
