Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388AbbA1UeI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 15:34:08 -0500
Date: Wed, 28 Jan 2015 13:55:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Matt Robinson <git@nerdoftheherd.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: Align EOF length to block in extent_same
Message-ID: <20150128125521.GD3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422295551-25402-1-git-send-email-git@nerdoftheherd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422295551-25402-1-git-send-email-git@nerdoftheherd.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 26, 2015 at 06:05:51PM +0000, Matt Robinson wrote:
> It is not currently possible to deduplicate the last block of files
> whose size is not a multiple of the block size, as the btrfs_extent_same
> ioctl returns -EINVAL if offset + size is greater than the file size or
> is not aligned to the fs block size.

Do you have a reproducer for that?

The alignment is required to let btrfs_clone and the extent dropping
functions to work. The inline files are not aligned and should not be
deduplicated anyway.
