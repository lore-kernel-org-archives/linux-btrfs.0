Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbbAOL2C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 06:28:02 -0500
Date: Thu, 15 Jan 2015 12:28:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: fix test btrfs/017 (qgroup shared extent
 accounting test)
Message-ID: <20150115112800.GB3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421277703-32154-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421277703-32154-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 11:21:43PM +0000, Filipe Manana wrote:
> Currently this test fails on 2 situations:
> 
> 1) The scratch device supports trim/discard. In this case any modern
>    version of mkfs.btrfs outputs a message (to stderr) informing that
>    a trim is performed, which the golden output doesn't expect:
> 
>    btrfs/017	 - output mismatch (see /git/xfstests/results//btrfs/017.out.bad)
>        --- tests/btrfs/017.out	2015-01-06 11:14:22.730143144 +0000
>        +++ /git/xfstests/results//btrfs/017.out.bad	2015-01-14 22:33:01.582195719 +0000
>        @@ -1,4 +1,5 @@
>         QA output created by 017
>        +Performing full device TRIM (100.00GiB) ...
>         wrote 8192/8192 bytes at offset 0
>           XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>         4096 4096
>         ...
>         (Run 'diff -u tests/btrfs/017.out /git/xfstests/results//btrfs/017.out.bad'  to see the entire diff)
> 
>     So like others tests do, just redirect mkfs' standard error.
> 
> 2) On platforms with a page size greater than 4Kb. At the moment btrfs
>    doesn't support a node/leaf size smaller than the page size, but it
>    supports a larger one. So use the max supported node size (64Kb) so
>    that the test runs on any platform currently supported by Linux.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
