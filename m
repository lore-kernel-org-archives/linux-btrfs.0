Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3JAOZo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 10:25:44 -0400
Date: Tue, 1 Oct 2013 16:25:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/015 regression test for prealloc with
 balance
Message-ID: <20131001142541.GG18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380292053-8123-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 10:27:33AM -0400, Josef Bacik wrote:
> +$BTRFS_UTIL_PROG fi ba $SCRATCH_MNT >> $seqres.full 2>&1 || \
> +	_fail "balance failed"

Please use the full command names, also 'filesystem balance' is the
obsolete form, it's spelled 'btrfs balance start'.

david
