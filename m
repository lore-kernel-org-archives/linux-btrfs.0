Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab3EJPDM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 11:03:12 -0400
Date: Fri, 10 May 2013 17:03:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: image: handle superblocks correctly on fs
 with big blocks
Message-ID: <20130510150309.GL16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
 <5188BED5.3040201@giantdisaster.de>
 <20130510112000.GJ16456@twin.jikos.cz>
 <518D0398.5000706@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <518D0398.5000706@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 10, 2013 at 04:26:32PM +0200, Stefan Behrens wrote:
> On 05/10/2013 13:20, David Sterba wrote:
> >On Tue, May 07, 2013 at 10:44:05AM +0200, Stefan Behrens wrote:
> >>On Mon,  6 May 2013 23:11:20 +0200, David Sterba wrote:
> >>>Superblock is always 4k, but metadata blocks may be larger. We have to
> >>>use the appropriate block size when doing checksums, otherwise they're
> >>>wrong.
> >>>
> >>>Signed-off-by: David Sterba <dsterba@suse.cz>
> >>>---
> >>>  btrfs-image.c | 27 +++++++++++++++++++++++----
> >>>  1 file changed, 23 insertions(+), 4 deletions(-)
> >>>
> >>>diff --git a/btrfs-image.c b/btrfs-image.c
> >>>index 188291c..dca7a28 100644
> >>>--- a/btrfs-image.c
> >>>+++ b/btrfs-image.c
> >>>@@ -469,6 +469,16 @@ static int read_data_extent(struct metadump_struct *md,
> >>>  	return 0;
> >>>  }
> >>>
> >>>+static int is_sb_offset(u64 offset) {
> >>>+	switch (offset) {
> >>>+		case 65536:
> >>>+		case 67108864:
> >>>+		case 274877906944:
> >>
> >>Using btrfs_sb_offset() and an if statement would produce the same code
> >>and would be more readable.
> >
> >It was there originally, but this function is called for each block and
> >I've optimized it a bit right away. I'll add a comment.
> 
> You have not optimized it. gcc does not generate a jump table with 274
> billion entries (I have verified it). The code is the same in both cases.

Point for you. I'll use btrfs_sb_offset.

david
