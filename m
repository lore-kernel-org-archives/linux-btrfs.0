Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3JAM7x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 08:59:53 -0400
Date: Tue, 1 Oct 2013 14:59:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs-progs: Add recursive defrag using -r option
Message-ID: <20131001125939.GC18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20ddb7ded6d0bedadd7dc68a2c29d7c3bd4b7906.1379963692.git.fholton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20ddb7ded6d0bedadd7dc68a2c29d7c3bd4b7906.1379963692.git.fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 03:18:17PM -0400, Frank Holton wrote:
> Add an option to defrag all files in a directory recursively.

I had this patch merged but still saw some problems. If there's eg. a
symlink to file on another filesystem, defrag fails with

"ERROR: defrag range ioctl not supported in this kernel, please try
without any options."

which does not match the error that occured.

In short, we have to use nftw and specify FTW_MOUNT (do not dive into
mountpoints) and FTW_PHYS (do not follow symlinks). Fixed and added to
integration. Please write the corresponding bits of manpage and send a
patch.

thanks,
david
