Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935201Ab3DHNLw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Apr 2013 09:11:52 -0400
Date: Mon, 8 Apr 2013 15:11:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Robert Buhren <robert@robertbuhren.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "btrfs send" fails with having too many open fd's
Message-ID: <20130408131149.GC18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51613541.3080009@robertbuhren.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51613541.3080009@robertbuhren.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 07, 2013 at 10:58:41AM +0200, Robert Buhren wrote:
> "6,7226,15012711248,-;VFS: file-max limit 799969 reached"

> Label: 'BACKUP'  uuid: 019e75e4-aa2e-495d-9711-28ef7150b1f3
>     Total devices 2 FS bytes used 137.35GB

> It takes a very long time before my system crashes (several hours) so i
> wasn't able to monitor when exactly the fd's increase.
> In the beginning "btrfs send" just opens less than 10 fd's, but at some
> point "btrfs send" must open much more.

It could be a case of

1) an endless loop, the file limit you've set is quite high (799969), I
doubt that so many open fd's are needed at any point.

2) missing file close after in some error path

The file's are open via
send_write
  open_cur_inode_file
    dentry_open

and closed from callbacks in close_cur_inode_file.

Case 2 looks more realistic, but I don't have an idea what could go
wrong.

david
