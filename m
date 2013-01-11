Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab3AKXBA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 18:01:00 -0500
Date: Fri, 11 Jan 2013 15:00:58 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        ablock84@googlemail.com
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130111230058.GN12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de> <50EFDBDD.1040104@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EFDBDD.1040104@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 05:31:09PM +0800, Anand Jain wrote:
>
> Mark,
>
> test case :
>  make (Do not run make all)
>  make install
Thanks for testing!

> generates the following error..
>
> install -m755 -d /usr/local/lib
> install libbtrfs.so.1.0 libbtrfs.so.1 libbtrfs.so /usr/local/lib
> install: cannot stat `libbtrfs.so.1.0': No such file or directory
> install: cannot stat `libbtrfs.so.1': No such file or directory
> install: cannot stat `libbtrfs.so': No such file or directory
> make: *** [install] Error 1

Ok, that's weird because this works fine for me. Just in case, I tried
against a clean checkout of btrfs-progs and with the patches taken from the
mailing list:

mfasheh@eris:/build/mfasheh/tmp> git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
Cloning into btrfs-progs...
<snip>
mfasheh@eris:/build/mfasheh/tmp> cd btrfs-progs/
mfasheh@eris:/build/mfasheh/tmp/btrfs-progs> git am ../to-apply
Applying: btrfs-progs: Add support for BTRFS_SEND_FLAG_NO_FILE_DATA
Applying: btrfs-progs: libify some parts of btrfs-progs
Applying: btrfs-progs: add send-test
/build/mfasheh/tmp/btrfs-progs/.git/rebase-apply/patch:39: trailing
whitespace.
 * This code is adapted from cmds-send.c and cmds-receive.c,
warning: 1 line adds whitespace errors.
mfasheh@eris:/build/mfasheh/tmp/btrfs-progs> make
<snip, but suffice to say it builds>
mfasheh@eris:/build/mfasheh/tmp/btrfs-progs> mkdir tmpinst
mfasheh@eris:/build/mfasheh/tmp/btrfs-progs> make prefix=tmpinst install
cd man; make install
make[1]: Entering directory `/build/mfasheh/tmp/btrfs-progs/man'
install -m755 -d tmpinst/man/man8
install -m 644 mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz
btrfs-show.8.gz btrfs.8.gz tmpinst/man/man8
make[1]: Leaving directory `/build/mfasheh/tmp/btrfs-progs/man'
install -m755 -d tmpinst/bin
install btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck
btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert
btrfs-find-root btrfs-restor
install -m755 -d tmpinst/lib
install libbtrfs.so.1.0 libbtrfs.so.1 libbtrfs.so tmpinst/lib
install -m755 -d tmpinst/include/btrfs
install send-stream.h send-utils.h send.h rbtree.h btrfs-list.h crc32c.h
list.h kerncompat.h radix-tree.h extent-cache.h extent_io.h ioctl.h ctree.h
tmpinst/include/btrfs


Can you take a log of the build process and send that to me. If libbtrfs
isn't building on your end for some reason than that would be why it won't
install.

Thanks again for testing this Anand!
	--Mark

--
Mark Fasheh
