Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:23985 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754435AbdESAob (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:44:31 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 280AAAC02B0
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 09:33:15 +0900 (JST)
Subject: Re: Btrfs progs release 4.11
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170518143554.24900-1-dsterba@suse.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <94fa4e60-adfa-dfb8-ce6f-38b4c079fdf3@jp.fujitsu.com>
Date: Fri, 19 May 2017 09:32:58 +0900
MIME-Version: 1.0
In-Reply-To: <20170518143554.24900-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Could you please apply the following patch?

 [PATCH] btrfs-progs: tests: remove variable quotation from convert-tests
 http://marc.info/?l=linux-btrfs&m=149490441323349&w=2

Thanks,
Tsutomu

On 2017/05/18 23:35, David Sterba wrote:
> Hi,
> 
> btrfs-progs version 4.11 have been released. It's a small release with handful
> of fixes and minor other updates.
> 
> Changes:
>   * receive: fix handling empty stream with -e (multi-stream)
>   * send dump: fix printing long file names
>   * stability fixes for: dump-super, print-tree, check
>   * option parser updates: global options are parsed before the subcommand name
>     (old xfstests will fail)
>   * new and updated tests
>   * documentation updates
> 
> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> 
> Shortlog:
> 
> Christian Brauner (3):
>       btrfs-progs: fix btrfs send & receive with -e flag
>       btrfs-progs: tests: misc/018-receive use receive -e to terminate on end marker
>       btrfs-progs: receiv: fail on first -ENODATA only
> 
> Christophe de Dinechin (3):
>       btrfs-progs: check: disambiguate between cases where add_tree_backref fails
>       btrfs-progs: check: prevent attempt to insert extent record with max_size==0
>       btrfs-progs: check: make max_size consistent with nr
> 
> David Sterba (10):
>       btrfs-progs: docs: mount options, enhance ssd/nossd
>       btrfs-progs: rework option parser to use getopt for global options
>       btrfs-progs: README: sort bug reports means by preference
>       btrfs-progs: docs: btrfs-replace, fix typo
>       btrfs-progs: balance: minor wording adjustment for full balance warning
>       btrfs-progs: docs: update formatting and wording for btrfs(5)
>       btrfs-progs: fssum: fix warning, include correct header for major()
>       btrfs-progs: tests: fix misc/019-receive-clones-on-munted-subvol
>       btrfs-progs: update CHANGES for v4.11
>       Btrfs progs v4.11
> 
> Evan Danaher (1):
>       btrfs-progs: send: always print a space after path in dump
> 
> Hans van Kranenburg (2):
>       btrfs-progs: docs: Fix missing newline in man 5 btrfs
>       btrfs-progs: docs: Fix newlines for man btrfstune
> 
> Lakshmipathi.G (3):
>       btrfs-progs: misc-tests: Superblock corruption and recovery using backup
>       btrfs-progs: tests: add variable quotation to fsck-tests
>       btrfs-progs: tests: add variable quotation to convert-tests
> 
> Lu Fengqi (4):
>       btrfs-progs: dump-super: check array_size in print_sys_chunk_array
>       btrfs-progs: print-tree: add validation to print_chunk
>       btrfs-progs: tests: fssum, fix memory leak
>       btrfs-progs: tests: Fix fuzz-test for bko-161821.raw.txt
> 
> Qu Wenruo (6):
>       btrfs-progs: Fix memory leak when 0 sized block group item is found
>       btrfs-progs: check: Fix memory leak in check_chunks_and_extents
>       btrfs-progs: Use more strict check to read out tree root
>       btrfs-progs: check: Avoid reading beyond item boundary for inode_ref
>       btrfs-progs: check: Avoid reading beyond item boundary for dir_item and dir_index
>       btrfs-progs: print-tree: Add leaf flags and backref revision output
> 
> Su Yue (1):
>       btrfs-progs: check: Fix heap use after free
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
