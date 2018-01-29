Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:39780 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbeA2Vn4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 16:43:56 -0500
Received: by mail-pg0-f44.google.com with SMTP id w17so5499771pgv.6
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 13:43:56 -0800 (PST)
Date: Mon, 29 Jan 2018 13:43:54 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 04/26] libbtrfsutil: add btrfs_util_is_subvolume() and
 btrfs_util_subvolume_id()
Message-ID: <20180129214354.GA1362@vader.DHCP.thefacebook.com>
References: <cover.1516991902.git.osandov@fb.com>
 <ec89f2b55edb450ce4fcbe1485ae8f57ed51187c.1516991902.git.osandov@fb.com>
 <c1c4fa63-7ab5-ad6a-d1a4-066ac58be161@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c1c4fa63-7ab5-ad6a-d1a4-066ac58be161@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 12:24:26PM +0200, Nikolay Borisov wrote:
> On 26.01.2018 20:40, Omar Sandoval wrote:
[snip]
> > +/*
> > + * This intentionally duplicates btrfs_util_f_is_subvolume() instead of opening
> > + * a file descriptor and calling it, because fstat() and fstatfs() don't accept
> > + * file descriptors opened with O_PATH on old kernels (before v3.6 and before
> > + * v3.12, respectively), but stat() and statfs() can be called on a path that
> > + * the user doesn't have read or write permissions to.
> > + */
> > +__attribute__((visibility("default")))
> 
> Why do we need to explicitly set the attribute visibility to default,
> isn't it implicitly default already?

Ah, I forgot to add -fvisibility=hidden to the build rule when I ported
this to the btrfs-progs Makefile, that's why that's there. I'll add
-fvisibility=hidden to the Makefile.
