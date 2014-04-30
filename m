Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33776 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbaD3MPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 08:15:00 -0400
Received: by mail-vc0-f173.google.com with SMTP id ik5so2022114vcb.4
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 05:14:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140418144801.GG29256@suse.cz>
References: <20140416171219.GC29256@twin.jikos.cz>
	<1397668577-846-1-git-send-email-dsterba@suse.cz>
	<534F24A0.5000304@cn.fujitsu.com>
	<20140418144801.GG29256@suse.cz>
Date: Wed, 30 Apr 2014 13:14:59 +0100
Message-ID: <CALOYprUDC-FR9qz-EJhnuoHZzS=9g3cdbv1Q+gSzJgnkb=LHxg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While trying to view the btrfs-check manpage today (using
integration-20140429), I noticed that the current symlink overwrites
the actual btrfs-check manpage, making an unusable, cyclic link:

    $ man btrfs-check
    man: can't resolve /usr/share/man/man8/btrfs-check.8.gz: Too many
levels of symbolic links
    No manual entry for btrfs-check

I believe you forgot to add the file name of the symlink at the end of
the line, e.g.

    $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)

should be

    $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz

Cheers,


WorMzy
