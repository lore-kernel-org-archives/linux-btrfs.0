Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60685 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdJFSt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 14:49:56 -0400
Date: Fri, 6 Oct 2017 20:48:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix read_one_chunk() return error code
Message-ID: <20171006184811.GC3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171006100443.20007-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171006100443.20007-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 06:04:42PM +0800, Anand Jain wrote:
> EIO is for IO (RW) failures, use correct error return
> codes at two locations with in read_one_chunk(). Also
> adds a small cleanup.

This patch does 3 things, please split it, and drop the cleanup part.

1) switch add_missing_dev to ERR_PTR/IS_ERR return value and update
   callers
2) change return value from EIO to EINVAL in case a device is missing
   and mount is not degraded

I'm not sure that EINVAL is the right error code, as it's used when the
mount options are unrecognized or wrong. I agree that EIO is not the
right code either, as it's reserved for "true" IO errors. Possibly it
could be ENOENT or EAGAIN followed by the syslog message.
