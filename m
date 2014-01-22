Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbaAVN1b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 08:27:31 -0500
Date: Wed, 22 Jan 2014 14:27:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] xfstests: btrfs: cross-subvolume sparse copy
Message-ID: <20140122132729.GJ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390304448-25752-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390304448-25752-1-git-send-email-koen.de.wit@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 21, 2014 at 12:40:48PM +0100, Koen De Wit wrote:
> +btrfs subvol delete $SUBVOL1 >/dev/null 2>&1
> +btrfs subvol delete $SUBVOL2 >/dev/null 2>&1

Please use $BTRFS_UTIL_PROG instead of 'btrfs' and don't shorten the
command names, ie 'subvolume'.

> +cp --reflink $TESTDIR1/file1 $SUBVOL1
> +cp --reflink $TESTDIR1/file1 $SUBVOL2
> +cp --reflink $SUBVOL1/file2 $TESTDIR1/
> +cp --reflink $SUBVOL1/file2 $SUBVOL2
> +cp --reflink $SUBVOL2/file3 $TESTDIR1/
> +cp --reflink $SUBVOL2/file3 $SUBVOL1

--reflink without any parameter means 'always', that's what we want, but
can we possibly make it explicit? 'cp' is an external tool and if the
default changes, the test would not work as expected.

Otherwise ok,
Reviewed-by: David Sterba <dsterba@suse.cz>
