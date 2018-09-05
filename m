Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbeIERa5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 13:30:57 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE00BAEAE
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 13:00:45 +0000 (UTC)
Date: Wed, 5 Sep 2018 15:00:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: qgroup: Deprecate unused features for
 btrfs_qgroup_inherit()
Message-ID: <20180905130030.GW24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180831022930.3465-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180831022930.3465-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:29:27AM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_inherit_check
> Which is based on v4.19-rc1 tag.
> 
> This patchset will first set btrfs_qgroup_inherit structure size limit
> from PAGE_SIZE to fixed SZ_4K.
> I understand this normally will cause compatibility problem, but
> considering how minor this feature is and no sane guy should use it for
> over 100 qgroups, it should be fine in real world.

Agreed, please update the changelog of 1st patch with description on
what will stop working and under what conditions. The 4k limit sounds
good enough, the real difference would be on architectures with larger
page sizes where the feature would be used.

> The 2nd patch introduce check function for btrfs_qgroup_inherit
> structure and deprecates the following features:
> 1) limit set
>    Never utilized by btrfs-progs from the beginning.
> 
> 2) copy rfer/excl
>    Although btrfs-progs provides support for it as a hidden,
>    undocumented feature, it's the easiest way to screw up qgroup
>    numbers.
>    And we already have patches wondering around the ML to remove such
>    support.

The deprecation should be done in a few steps. First issue a warning
that the feature is deprecated and will be removed in release X. Then
wait until somebody complains (or not) and remove the code in release X.

The X is something like 4.22, ie. at least 2 cycles after the
deprecation warning is added.
