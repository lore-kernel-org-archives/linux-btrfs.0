Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbbJ2OWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 10:22:35 -0400
Date: Thu, 29 Oct 2015 15:21:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Luke Dashjr <luke@dashjr.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCHv2] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
Message-ID: <20151029142108.GY13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201510290822.26515.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201510290822.26515.luke@dashjr.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 29, 2015 at 08:22:21AM +0000, Luke Dashjr wrote:
> 32-bit ioctl uses these rather than the regular FS_IOC_* versions. They can
> be handled in btrfs using the same code. Without this, 32-bit {ch,ls}attr
> fail.
> 
> Signed-off-by: Luke Dashjr <luke-jr+git@utopios.org>
> Cc: stable@vger.kernel.org

Reviewed-by: David Sterba <dsterba@suse.com>
