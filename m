Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206AbbLGPWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 10:22:10 -0500
Date: Mon, 7 Dec 2015 16:20:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/25] Btrfs-convert rework to support separate chunk
 type
Message-ID: <20151207152011.GE4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 01, 2015 at 03:11:20PM +0800, Qu Wenruo wrote:
> Here comes the 2st version of btrfs-convert rework.
> This time, it is rebased to co-operate with David new abstraction work
> for incoming reiserfs support.
> (Sorry David, your reiserfs support will need more modification as the
> abstraction facility is also modified in this patchset)

Yeah seems like the removed functions are not needed, the reiser code
should be portable on top of the v2 code.

> Any test is welcomed, and it can already pass the convert test from
> btrfs-progs. (Since the test doesn't test rollback function)

I'll start merging the patches to devel when I'm sure I understand the
change so more reviewers can help and are welcome too. The unmerged
patches would be put into an integration branch, hopefully this would
work.

> 2. Structurized make_btrfs_v2()
>    Unlike old make_btrfs() which is a mess of hand written codes

I though 99% of our code is hand written :)

>    new
>    make_btrfs_v2() is all structurized and should be easy for later
>    expansion.
