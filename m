Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbcFAVcM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 17:32:12 -0400
Date: Wed, 1 Jun 2016 14:32:10 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>, chris@suse.de,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v7 0/8] Inband dedupe for btrfs-progs
Message-ID: <20160601213210.GK7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492670-31596-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492670-31596-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:37:42PM +0800, Qu Wenruo wrote:
> No much change from previous version.
> 1) Rebased to latest devel branch
> 
> 2) Update ctree.h to follow kernel structure change
> 
> 3) Update print-tree to follow kernel structure change
> 
> Qu Wenruo (7):
>   btrfs-progs: Basic framework for dedupe command group
>   btrfs-progs: dedupe: Add enable command for dedupe command group
>   btrfs-progs: dedupe: Add disable support for inband dedupelication
>   btrfs-progs: dedupe: Add status subcommand
>   btrfs-progs: Add dedupe feature for mkfs and convert
>   btrfs-progs: Add show-super support for new DEDUPE flag
>   btrfs-progs: debug-tree: Add dedupe tree support
> 
> Wang Xiaoguang (1):
>   btrfs-progs: property: add a dedupe property
> 
>  Documentation/Makefile.in             |   1 +
>  Documentation/btrfs-dedupe.asciidoc   | 150 ++++++++++++++++
>  Documentation/btrfs-property.asciidoc |   2 +
>  Documentation/btrfs.asciidoc          |   4 +
>  Documentation/mkfs.btrfs.asciidoc     |   9 +
>  Makefile.in                           |   3 +-
>  btrfs-completion                      |   6 +-
>  btrfs-convert.c                       |  19 +-
>  btrfs.c                               |   1 +
>  cmds-dedupe.c                         | 329 ++++++++++++++++++++++++++++++++++

Can we please have seperate and obvious namespaces for in-band dedupe and
out-of-band dedupe commands? I realize that there is no oob-dedupe
funcationality in btrfs-progs today but I would like to avoid confusing
users in the case that this code hits btrfs-progs.

Specifically by this, I mean I'd like to see anything except 'dedupe' as the
btrfs command, so a user who sees 'btrfs dedupe ....' is not confusing the
two forms we have.

I don't personally care what other name is used and of course it could have
'dedupe' in the name just not solely 'dedupe'. As a poor example, we could
call it 'btrfs inband-dedupe ...'.

Thanks,
	--Mark

--
Mark Fasheh
