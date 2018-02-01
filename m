Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbeBAQam (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 11:30:42 -0500
Date: Thu, 1 Feb 2018 17:28:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 04/26] libbtrfsutil: add btrfs_util_is_subvolume() and
 btrfs_util_subvolume_id()
Message-ID: <20180201162828.GM18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1516991902.git.osandov@fb.com>
 <ec89f2b55edb450ce4fcbe1485ae8f57ed51187c.1516991902.git.osandov@fb.com>
 <c1c4fa63-7ab5-ad6a-d1a4-066ac58be161@suse.com>
 <20180129214354.GA1362@vader.DHCP.thefacebook.com>
 <fdfbec55-a04b-2009-b200-35bf1aa090e9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fdfbec55-a04b-2009-b200-35bf1aa090e9@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 08:54:08AM +0200, Nikolay Borisov wrote:
> 
> 
> On 29.01.2018 23:43, Omar Sandoval wrote:
> > On Mon, Jan 29, 2018 at 12:24:26PM +0200, Nikolay Borisov wrote:
> >> On 26.01.2018 20:40, Omar Sandoval wrote:
> > [snip]
> >>> +/*
> >>> + * This intentionally duplicates btrfs_util_f_is_subvolume() instead of opening
> >>> + * a file descriptor and calling it, because fstat() and fstatfs() don't accept
> >>> + * file descriptors opened with O_PATH on old kernels (before v3.6 and before
> >>> + * v3.12, respectively), but stat() and statfs() can be called on a path that
> >>> + * the user doesn't have read or write permissions to.
> >>> + */
> >>> +__attribute__((visibility("default")))
> >>
> >> Why do we need to explicitly set the attribute visibility to default,
> >> isn't it implicitly default already?
> > 
> > Ah, I forgot to add -fvisibility=hidden to the build rule when I ported
> > this to the btrfs-progs Makefile, that's why that's there. I'll add
> > -fvisibility=hidden to the Makefile.
> 
> Right, it could be a good idea to hide the visibility attribute behind
> an eloquent macro i.e. (PUBLIC|LIBRARY)_FUNC or some such.

Macro would be better (but is not needed for the initial version).

Alternatively the library .sym file can externally track the exported
symbols and also track versioning.
