Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF666C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 16:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89EA42075B
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 16:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfDOQ0a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 12:26:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:49076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726298AbfDOQ0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 12:26:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A6B2AEED;
        Mon, 15 Apr 2019 16:26:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 38257DA9C7; Mon, 15 Apr 2019 18:27:32 +0200 (CEST)
Date:   Mon, 15 Apr 2019 18:27:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL REQUEST] btrfs-progs updates, the main part
Message-ID: <20190415162727.GB22216@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <48f7ce97-b1cb-b7f8-5b4d-33c8e3737fcf@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7ce97-b1cb-b7f8-5b4d-33c8e3737fcf@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 11, 2019 at 01:54:44PM +0800, Qu Wenruo wrote:
> Here is my pull request for the btrfs-progs:
> https://github.com/adam900710/btrfs-progs/tree/for_devel
> 
> The basis is the following commit from your devel branch:
> commit a8389337c5a0e7c3fb32ff91d557889c036da73a
> Author: Adam Borowski <kilobyte@angband.pl>
> Date:   Mon Feb 25 19:16:44 2019 +0100
> 
>     btrfs-progs: defrag: open files RO on new enough kernels

Please rebase the branch on top of current devel, with "btrfs-progs:
Remove get_argv0_buf". I had a few patches merged but the branch was not
public so there's some duplication.

> This branch drops the following commit in your devel branch:
> commit 4e8eb31f048f3fe9a68aacb58e4c0714df25b5c4 (david/devel)
> Author: Qu Wenruo <wqu@suse.com>
> Date:   Fri Sep 14 15:49:44 2018 +0800
> 
>     btrfs-progs: Do metadata preallocation as long as we're not
> modifying extent tree

This fixes issue #123, is there another fix? I'll drop the patch from
devel as it fails the test so the revert won't be needed.

> Due to test failure on looping chunk allocation.
> 
> The branch passes all selftests, except misc/035 which is a known problem.
> 
> This pull request include the following features:
> 
> Core change:
> - check --repair
>   * Flush/FUA support to avoid breaking metadata CoW
>       Now btrfs-progs crashing or transaction aborted won't cause
>       new transid error.
> - device scan:
>   * Add the ability to forget a device
> 
> Fixes and Enhancement:
> - generic
>   * Try best copy when reading tree blocks.
>   * Skip unnecessary retry when one tree block copy fails.
>   * Avoid back tree block to populate tree block cache.
> - check
>   * File extents repair no longer relies data in extent tree.
>   * New ability to check and repair free space cache invalid inode mode.
>   * Update backup roots when commit transaction.
> - mkfs:
>   * Enlarge metadata chunk size to follow kernel size.
> - defrag
>   * open file in RO for newer kernel.
> - gitignore
>   * Ignore hidden files.
> - qgroup report
>   * Handle unrecognized sort string.
> - receive
>   * New quite mode.
> - Misc
>   * More cleanup for fs_info <-> root parameters.

Nice, I'll put it to the merge commit once the branch is ready.

> Adam Borowski (2):
>   btrfs-progs: fix kernel version parsing on some versions past 3.0
>   btrfs-progs: defrag: open files RO on new enough kernels
> 
> Anand Jain (3):
>   btrfs-progs: device scan: add new option to forget one or all scanned
>     devices
>   btrfs-progs: dev replace: check for no result before using results
>   btrfs-progs: dev replace: gracefully handle the exclusive operation
>     report
> 
> David Sterba (21):
>   btrfs-progs: device scan: constify path argument
>   btrfs-progs: device scan: update help text
>   btrfs-progs: device scan: update help text
>   btrfs-progs: docs: add scan --forget
>   btrfs-progs: device scan: update error messages
>   btrfs-progs: device: update help texts
>   btrfs-progs: help: add helper for unrecognized option error message
>   btrfs-progs: help: update messages of argc constraint checkers
>   btrfs-progs: help: use unknown command option helper
>   btrfs-progs: help: don't print usage on wrong argument counts
>   btrfs-progs: prop: let parsing helper return error to the caller
>   btrfs-progs: prop: don't print full usage on invalid arguments
>   btrfs-progs: prop: return only common error values
>   btrfs-progs: find-root: use common usage helper for uknown option
>   btrfs-progs: find-root: don't dump usage on wrong argument count
>   btrfs-progs: find-root: use the common help infrastructure
>   btrfs-progs: qgroup: report unknown option
>   btrfs-progs: qgroup: remove unused option handling
>   btrfs-progs: qgroup show: report errors while parsing sort string
>   btrfs-progs: qgroup show: report unrecognized format of sort string
>   btrfs-progs: qgoup: propagate errors from
>     btrfs_qgroup_parse_sort_string

For pull-based workflows there are some things that I'd require, based
on what I do for kernel patches, so let's use this one to set the
expectations:

The excerpt above from the shortlog (and other commits) was not intended
to be pulled, so it should not be in the shortlog.

Please note that all patches need to have signed-off-by by the
committer. This is not true for

- btrfs-progs: fsck-test: enable lowmem repair for case 001
- btrfs-progs: tests: add case for inode lose one file extent

The commits that do revert do not need the 'btrfs-progs:' prefix,
without it it's obvious in the patch subject list that those are
exceptions.

One thing that I edit in almost all commit is the order of tags, briefly
documented at
https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Ordering

I don't require a signed tag to pull as the amount of pull requests is
not going to be high, review is feasible for me.

One thing that might be new for you is that you'll be the first get
blamed for everything what's in the branch you send to pull, then the
original authors :) It's good to favor quality over quantity.

There's probably more of lower importance, we'll find out along the way.
