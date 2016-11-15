Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33995 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932502AbcKOQAw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 11:00:52 -0500
Date: Tue, 15 Nov 2016 17:00:37 +0100
From: David Sterba <dsterba@suse.cz>
To: ethanwu <ethanwu@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: check: Handle drop_progress correctly
 for deleted subvolume
Message-ID: <20161115160037.GR12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Oct 13, 2016 at 07:09:47PM +0800, ethanwu wrote:
> The patchsets fixes 2 problems in checking deleted subvolume.
> 
> First, there are cases missing in checking drop_key, this add up the missing cases,
> so the skipping flow could work correctly.
> 
> Second, the drop key is only applied to subvolume tree. This should be applied to the
> corresponding relocation tree of the deleted subvolume as well.

the changelogs are very good, unfortunatelly I'm not very familiar with
the parts so I'd need a review from somebody else, otherwise the patches
will be on a slow merge path. Would be good if you could provide crafted
images where the bug exhibits. Thanks.
