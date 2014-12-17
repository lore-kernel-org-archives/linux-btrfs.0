Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaLQOH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 09:07:28 -0500
Date: Wed, 17 Dec 2014 15:07:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Karel Zak <kzak@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-prog: improve build-system by autoconf
Message-ID: <20141217140726.GY27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 12, 2014 at 01:35:14PM +0100, Karel Zak wrote:
> This is first step to make btrfs-progs build system more conventional
> for userspace users and developers. All is implemented by small incremental
> patches to keep things review-able.

Thanks. I went through the patches and haven't found major problems. The
changes are affecting build system and this will need a longer period
before all distros have a chance to adapt to that, so I'm postponing it
to 3.19.

> Note that there is also strange unused btrfs_convert_libs, btrfs_image_libs and
> btrfs_fragments_libs variables with things like "-lgd -lpng -ljpeg -lfreetype".
> I guess it's some legacy, right? I didn't touch these variables as I have no
> clue about sense of this stuff.

No, it's part of the macro magic. There are pattern rules that accept
any source in the form btrfs-something.c and also pick the libraries for
that from variable btrfs_something_libs:

btrfs-%: $(objects) $(libs) btrfs-%.o
        @echo "    [LD]     $@"
        $(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))

This is for convenience, if this turns out to be hard to do with in combination
with autotools, I don't insist on keeping it but it has simplified the Makefile
significantly.
