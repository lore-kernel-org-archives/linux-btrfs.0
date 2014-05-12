Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506AbaELOJX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 10:09:23 -0400
Date: Mon, 12 May 2014 16:09:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
Message-ID: <20140512140917.GA6917@suse.cz>
Reply-To: dsterba@suse.cz
References: <20140416171219.GC29256@twin.jikos.cz>
 <1397668577-846-1-git-send-email-dsterba@suse.cz>
 <534F24A0.5000304@cn.fujitsu.com>
 <20140418144801.GG29256@suse.cz>
 <536AE073.2070307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <536AE073.2070307@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 08, 2014 at 09:40:03AM +0800, Qu Wenruo wrote:
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年04月18日 22:48
> >On Thu, Apr 17, 2014 at 08:47:28AM +0800, Qu Wenruo wrote:
> >>>@@ -73,6 +74,7 @@ install: install-man
> >>>  install-man: man
> >>>  	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
> >>>  	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
> >>>+	$(LNS) btrfs-check.txt $(DESTDIR)$(man8dir)
> >>Shouldn't the source of soft link be btrfs-check.8.gz. ?
> Forgot to mention that the dest is also wrong. This will make
> $(DESTDIR)$(man8dir)/btrfs-check.8.gz to be a
> infinite loop(pointing to it self).
> The correct one should be like the following:
> +       $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz

Thanks, it was reported & fixed a few days ago, though it's not in the
integration branch, lag is on my side.

https://patchwork.kernel.org/patch/4115501/
