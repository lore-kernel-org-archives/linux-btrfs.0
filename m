Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbaEEO5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 10:57:19 -0400
Date: Mon, 5 May 2014 16:57:18 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
Message-ID: <20140505145718.GR5988@suse.cz>
Reply-To: dsterba@suse.cz
References: <20140416171219.GC29256@twin.jikos.cz>
 <1397668577-846-1-git-send-email-dsterba@suse.cz>
 <534F24A0.5000304@cn.fujitsu.com>
 <20140418144801.GG29256@suse.cz>
 <CALOYprUDC-FR9qz-EJhnuoHZzS=9g3cdbv1Q+gSzJgnkb=LHxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprUDC-FR9qz-EJhnuoHZzS=9g3cdbv1Q+gSzJgnkb=LHxg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 01:14:59PM +0100, WorMzy Tykashi wrote:
>     $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)
> 
> should be
> 
>     $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz

Thank you, fix sent.
