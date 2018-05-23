Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51555 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933916AbeEWSGb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 14:06:31 -0400
Date: Wed, 23 May 2018 20:03:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: [PATCH 0/2] Btrfs: fix partly checksummed file races
Message-ID: <20180523180347.GC6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1527026445.git.osandov@fb.com>
 <20180523101714.GZ6649@twin.jikos.cz>
 <20180523171414.GA12533@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523171414.GA12533@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 10:14:14AM -0700, Omar Sandoval wrote:
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c

> The clone fix and device remove fix are in that branch, too. Let me know
> if you'd prefer it as patches.

The diff like that is fine, there likely will be more conflicts with
followup patches that need to be resolved anyway. If you do that and
find something worth pointing out then it's good to be mentioned, but
otherwise I'm not asking you or other reporter to also post the resolved
version. Thanks.
