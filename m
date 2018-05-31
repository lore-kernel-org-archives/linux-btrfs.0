Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754628AbeEaLnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 07:43:17 -0400
Date: Thu, 31 May 2018 13:40:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs-progs: check: verify symlinks with
 append/immutable flags
Message-ID: <20180531114031.GP3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180515013324.18838-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 15, 2018 at 09:33:21AM +0800, Su Yue wrote:
> This patchset can be fetch from my github:
> https://github.com/Damenly/btrfs-progs/commits/odd_inode_flags
> It's based on devel.
> 
> symlinks should never have append/immutable attributes.
> This patchset enables btrfs check to verify such corruption.
> 
> PATCH[1] is for original mode.
> PATCH[2] is for original mode.
> 
> PATCH[3] adds a test image.
> For further use, the directory is called bad-inode-flags.
> 
> #issue 133
> 
> ---
> Changelog:
> v2:
>   Use "rec->errors |=" instead of "rec->errors =" in patch[1].
>   Define new error bit of invalid inode flags in lowmem mode.
>   Adjust print message in patch[2]. Thanks, Qu and Nikolay.
>   Rename test directory from odd-inode-flags to bad-inode-flags.
> 
> Su Yue (3):
>   btrfs-progs: check: check symlinks with append/immutable flags
>   btrfs-progs: lowmem: check symlinks with append/immutable flags
>   btrfs-progs: fsck-tests: add test case to check symlinks with bad
>     flags

Applied, thanks.
