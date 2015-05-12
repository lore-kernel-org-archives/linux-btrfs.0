Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbbELP3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 11:29:46 -0400
Date: Tue, 12 May 2015 17:29:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] fstests: regression test for btrfs file range
 cloning
Message-ID: <20150512152944.GD23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430614414-2752-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430614414-2752-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 03, 2015 at 01:53:34AM +0100, Filipe Manana wrote:
> Test btrfs file range cloning with the same file as a source and
> destination.
> 
> This tests a specific scenario where the extent layout of the file
> confused the clone ioctl implementation making it return -EEXIST to
> userspace. This issue was fixed by the following linux kernel patch:
> 
>    Btrfs: fix range cloning when same inode used as source and destination
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
Tested-by: David Sterba <dsterba@suse.cz>
