Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753780AbdIDQKy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 12:10:54 -0400
Date: Mon, 4 Sep 2017 18:09:26 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: inspect-internal rootid: Allow a file to be
 specified
Message-ID: <20170904160926.GB31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1d4ee017-33a3-f7dc-7347-a98b099e5f5b@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1d4ee017-33a3-f7dc-7347-a98b099e5f5b@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 04, 2017 at 02:05:34PM +0900, Misono, Tomohiro wrote:
> Since cmd_inspect_rootid() calls btrfs_open_dir(), it rejects a file to
> be spcified. But as the document says, a file should be supported.
> 
> This patch introduces btrfs_open_file_or_dir(), which is a counterpart
> of btrfs_open_dir(), to safely check and open btrfs file or directory.
> The original btrfs_open_dir() codes are moved to btrfs_open() and shared
> by both function.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied, thanks. Can you please send a testcase for that?
