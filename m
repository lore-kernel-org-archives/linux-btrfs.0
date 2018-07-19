Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbeGSQYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:24:04 -0400
Date: Thu, 19 Jul 2018 17:40:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Rename EXTENT_BUFFER_DUMMY to
 EXTENT_BUFFER_PRIVATE
Message-ID: <20180719154010.GU26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-4-git-send-email-nborisov@suse.com>
 <20180629124633.GR2287@twin.jikos.cz>
 <97349690-b129-1b5b-17c5-4363fe2a879d@gmx.com>
 <c175a9b1-e13f-34e4-65dc-3957c09cb2b5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c175a9b1-e13f-34e4-65dc-3957c09cb2b5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 04:42:41PM +0300, Nikolay Borisov wrote:
> 
> 
> On 29.06.2018 16:07, Qu Wenruo wrote:
> > 
> > 
> > On 2018年06月29日 20:46, David Sterba wrote:
> >> On Wed, Jun 27, 2018 at 04:38:24PM +0300, Nikolay Borisov wrote:
> >>> EXTENT_BUFFER_DUMMY is an awful name for this flag. Buffers which have
> >>> this flag set are not in any way dummy. Rather, they are private in
> >>> the sense that are not linked to the global buffer tree. This flag has
> >>> subtle implications to the way free_extent_buffer work for example, as
> >>> well as controls whether page->mapping->private_lock is held during
> >>> extent_buffer release. Pages for a private buffer cannot be under io,
> >>> nor can they be written by a 3rd party so taking the lock is
> >>> unnecessary.
> >>>
> >>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> >>> ---
> >>>  fs/btrfs/disk-io.c   |  2 +-
> >>>  fs/btrfs/extent_io.c | 10 +++++-----
> >>>  fs/btrfs/extent_io.h |  2 +-
> >>>  3 files changed, 7 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>> index 8a469f70d5ee..1c655be92690 100644
> >>> --- a/fs/btrfs/disk-io.c
> >>> +++ b/fs/btrfs/disk-io.c
> >>> @@ -4093,7 +4093,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
> >>>  	 * enabled.  Normal people shouldn't be marking dummy buffers as dirty
> >>>  	 * outside of the sanity tests.
> >>>  	 */
> >>> -	if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &buf->bflags)))
> >>> +	if (unlikely(test_bit(EXTENT_BUFFER_PRIVATE, &buf->bflags)))
> >>
> >> This is going to be confusing. There's page Private bit,
> >> PAGE_SET_PRIVATE2 and EXTENT_PAGE_PRIVATE, that are somehow logically
> >> connected.
> >>
> >> I'd suggest EXTENT_BUFFER_CLONED or _UNMAPPED as it's created by
> >> btrfs_clone_extent_buffer or used in the disconnected way (ie. without
> >> the mapping).
> > 
> > UNMAPPED looks good to me.
> > (Or ANONYMOUS?)
> 
> I'm more leaning towards UNMAPPED at this point.

Ok, renamed it to EXTENT_BUFFER_UNMAPPED.
