Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43512 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756188AbaDVQFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 12:05:36 -0400
Date: Tue, 22 Apr 2014 09:07:09 -0700
From: David Brown <davidb@davidb.org>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive still gets out of sync in 3.14.0
Message-ID: <20140422160709.GA18265@davidb.org>
References: <20140322210455.GL28005@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20140322210455.GL28005@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 22, 2014 at 02:04:56PM -0700, Marc MERLIN wrote:
>After deleting a huge directory tree in my /home subvolume, syncing
>snapshots now fails with:
>
>ERROR: rmdir o1952777-157-0 failed. No such file or directory
>Error line 156 with status 1
>
> DIE: Code dump:
>   153	if [[ -n "$init" ]]; then
>   154	    btrfs send "$src_newsnap" | $ssh btrfs receive "$dest_pool/"
>   155	else
>   156	    btrfs send -p "$src_snap" "$src_newsnap" | $ssh btrfs receive "$dest_pool/"
>   157	fi
>   158	
>   159	# We make a read-write snapshot in case you want to use it for a chroot
>
>
>Is there anything useful I can provide before killing my snapshot and doing
>a full sync again?

I have been able to work around this by hacking up btrfs receive to
ignore the rmdir.  As far as I can tell (tree comparison) the
resulting tree is correct.

David

diff --git a/cmds-receive.c b/cmds-receive.c
index d6cd3da..5bd4161 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -492,6 +492,9 @@ static int process_rmdir(const char *path, void *user)
  		fprintf(stderr, "ERROR: rmdir %s failed. %s\n", path,
  				strerror(-ret));
  	}
+	// Ugly hack to work around kernel problem of sending
+	// redundant rmdirs.
+	ret = 0;
  
  	free(full_path);
  	return ret;
