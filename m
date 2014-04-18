Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaDROsE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 10:48:04 -0400
Date: Fri, 18 Apr 2014 16:48:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
Message-ID: <20140418144801.GG29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <20140416171219.GC29256@twin.jikos.cz>
 <1397668577-846-1-git-send-email-dsterba@suse.cz>
 <534F24A0.5000304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534F24A0.5000304@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 17, 2014 at 08:47:28AM +0800, Qu Wenruo wrote:
> >@@ -73,6 +74,7 @@ install: install-man
> >  install-man: man
> >  	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
> >  	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
> >+	$(LNS) btrfs-check.txt $(DESTDIR)$(man8dir)
> Shouldn't the source of soft link be btrfs-check.8.gz. ?

> >@@ -47,4 +49,3 @@ SEE ALSO
> >  `mkfs.btrfs`(8),
> >  `btrfs-scrub`(8),
> >  `btrfs-rescue`(8)
> >-`btrfsck`(8)
> Sorry to bother you but 'btrfs-scrub'/'btrfs-rescue' and 'btrfs-restore'
> seems also metioning 'btrfsck' and may also needs to remove 'btrfsck'.

Thanks for catching them, I'll fix it up.
