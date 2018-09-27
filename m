Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCB2C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 15:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5257216C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 15:53:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5257216C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbeI0WMi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 18:12:38 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:56550 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbeI0WMi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:12:38 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1834650AbeI0Pr7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 17:47:59 +0200
Date:   Thu, 27 Sep 2018 17:47:59 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     kreijack@inwind.it
Cc:     Daniel Kiper <dkiper@net-space.pl>, grub-devel@gnu.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/9] btrfs: Add support for reading a filesystem with a RAID 5 or RAID 6 profile.
Message-ID: <20180927154759.GA22053@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-2-kreijack@libero.it> <20180925153142.GA30715@router-fw-old.i.net-space.pl> <01115a89-3397-3cad-73b1-10495e11cb61@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01115a89-3397-3cad-73b1-10495e11cb61@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 10:40:32PM +0200, Goffredo Baroncelli wrote:
> On 25/09/2018 17.31, Daniel Kiper wrote:
> > On Wed, Sep 19, 2018 at 08:40:32PM +0200, Goffredo Baroncelli wrote:
> >> From: Goffredo Baroncelli <kreijack@inwind.it>
> >>
> >> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> >> ---
> >>  grub-core/fs/btrfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 66 insertions(+)
> >>
> >> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> >> index be195448d..56c42746d 100644
> >> --- a/grub-core/fs/btrfs.c
> >> +++ b/grub-core/fs/btrfs.c
> >> @@ -119,6 +119,8 @@ struct grub_btrfs_chunk_item
> >>  #define GRUB_BTRFS_CHUNK_TYPE_RAID1         0x10
> >>  #define GRUB_BTRFS_CHUNK_TYPE_DUPLICATED    0x20
> >>  #define GRUB_BTRFS_CHUNK_TYPE_RAID10        0x40
> >> +#define GRUB_BTRFS_CHUNK_TYPE_RAID5         0x80
> >> +#define GRUB_BTRFS_CHUNK_TYPE_RAID6         0x100
> >>    grub_uint8_t dummy2[0xc];
> >>    grub_uint16_t nstripes;
> >>    grub_uint16_t nsubstripes;
> >> @@ -764,6 +766,70 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
> >>  	      stripe_offset = low + chunk_stripe_length
> >>  		* high;
> >>  	      csize = chunk_stripe_length - low;
> >> +	      break;
> >> +	    }
> >> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
> >> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
> >> +	    {
> >> +	      grub_uint64_t nparities, block_nr, high, low;
> >> +
> >> +	      redundancy = 1;	/* no redundancy for now */
> >> +
> >> +	      if (grub_le_to_cpu64 (chunk->type) & GRUB_BTRFS_CHUNK_TYPE_RAID5)
> >> +		{
> >> +		  grub_dprintf ("btrfs", "RAID5\n");
> >> +		  nparities = 1;
> >> +		}
> >> +	      else
> >> +		{
> >> +		  grub_dprintf ("btrfs", "RAID6\n");
> >> +		  nparities = 2;
> >> +		}
> >> +
> >> +	      /*
> >> +	       * A RAID 6 layout consists of several blocks spread on the disks.
> >> +	       * The raid terminology is used to call all the blocks of a row
> >> +	       * "stripe". Unfortunately the BTRFS terminology confuses block
> >
> > Stripe is data set or parity (parity stripe) on one disk. Block has
> > different meaning. Please stick to btrfs terminology and say it clearly
> > in the comment. And even add a link to btrfs wiki page to ease reading.
> >
> > I think about this one:
> >   https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs#BLOCK_GROUPS.2C_CHUNKS.2C_RAID
> >
> >> +	       * and stripe.
> >
> > I do not think so. Or at least not so much...
>
> Trust me, generally speaking stripe is the "row" in the disks (without the parity); looking at the ext3 man page:
>
> ....
>                    stride=stride-size
>                           Configure  the  filesystem  for  a  RAID  array with
>                           stride-size filesystem blocks. This is the number of
>                           blocks  read or written to disk before moving to the
>                           next disk, which is sometimes  referred  to  as  the
>                           chunk   size.   This  mostly  affects  placement  of
>                           filesystem metadata like bitmaps at mke2fs  time  to
>                           avoid  placing them on a single disk, which can hurt
>                           performance.  It may also be used by the block allo???
>                           cator.
>
>                    stripe_width=stripe-width
>                           Configure  the  filesystem  for  a  RAID  array with
>                           stripe-width filesystem blocks per stripe.  This  is
>                           typically  stride-size * N, where N is the number of
>                           data-bearing disks in the  RAID  (e.g.  for  RAID  5
>                           there is one parity disk, so N will be the number of
>                           disks in the array minus 1).  This allows the  block
>                           allocator to prevent read-modify-write of the parity
>                           in a RAID stripe if possible when the data is  writ???
>                           ten.
>
> ....
> Looking at the RAID5 wikipedia page, it seems that the term "stripe"
> is coherent with the ext3 man page.

Ugh... It looks that I have messed up things. Sorry about that.

> I suspect that the confusion is due to the fact that in RAID1 a stripe
> is in ONE disk (because the others are like parities). In BTRFS the
> RAID5/6 code uses the structure of RAID1 with some minimal
> extensions...
>
> To be clear, I don't have problem to be adherent to the BTRFS
> terminology. However I found this very confusing because I was used to
> a different terminology. I am bit worried about the fact that grub

Yeah, I have the same feeling. However, I think that in btrfs code we
should stay with btrfs terms. Though I think that it make sense to
underline differences between btrfs and well known RAID here.

> uses both MD/DM code and BTRFS code; a quick look to the code (eg
> ./grub-core/disk/diskfilter.c) shows that the stripe_size field seems
> to be related to a disks row without parities.
>
> And... yes in BTRFS "chunk" is a completely different beast than what
> it is reported in the ext3 man page :-)

As I said above, please say it in the comment. This will ease reading
for people who are not used to btrfs terms.

> >> +	       *
> >> +	       *   Disk0  Disk1  Disk2  Disk3
> >> +	       *
> >> +	       *    A1     B1     P1     Q1
> >> +	       *    Q2     A2     B2     P2
> >> +	       *    P3     Q3     A3     B3
> >> +	       *  [...]
> >> +	       *
> >> +	       *  Note that the placement of the parities depends on row index.
> >> +	       *  In the code below:
> >> +	       *  - block_nr is the block number without the parities
> >
> > Well, it seems to me that the btrfs code introduces confusion not the
> > spec itself. I would leave code as is but s/block number/stripe number/.
>
> Ok I will replace the two terms. However I have to put a warning that this is a "BTRFS" terminology :-)

Yep, and please explain the differences at the beginning of the comment.

> >> +	       *    (A1 = 0, B1 = 1, A2 = 2, B2 = 3, ...),
> >> +	       *  - high is the row number (0 for A1...Q1, 1 for Q2...P2, ...),
> >> +	       *  - stripen is the disk number (0 for A1,Q2,P3, 1 for B1...),
> >
> > s/disk number/disk number in a row/
>
> This value doesn't depend by the row. So "number of disk" is more correct

Yes, but without "row" it is a bit confusing because it suggests that
it is an arbitrary number. Even if you give an example next to the
description. So, I am insisting on adding "in a row" here.

> >> +	       *  - off is the logical address to read
> >> +	       *  - chunk_stripe_length is the size of a block (typically 64k),
> >
> > s/a block/a stripe/

Taking into account discussion above I am not sure right now which one
is correct. Please double check and fix it if it is needed.

> >> +	       *  - nstripes is the number of disks,
> >
> > s/number of disks/number of disks in a row/
> ditto

As above, Is it total number of disks in array? I do not think so.
Hence, I think that "in a row" helps a bit. Even if it is not very
precise. However, if you come up with something better I am not
against it.

> > I miss the description of nparities here...
>
> Right:
> +              *  - nparities is the number of parities (1 for RAID5, 2 for RAID6);
> +              *    used only in RAID5/6 code.

LGTM.

> >> +	       *  - low is the offset of the data inside a stripe,
> >> +	       *  - stripe_offset is the disk offset,
> >
> > s/the disk offset/the data offset in an array/?
>
> Yes
>
> >
> >> +	       *  - csize is the "potential" data to read. It will be reduced to
> >> +	       *    size if the latter is smaller.
> >> +	       */
> >> +	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
> >> +
> >> +	      /*
> >> +	       * stripen is computed without the parities (0 for A1, A2, A3...
> >> +	       * 1 for B1, B2...).
> >> +	       */
> >> +	      high = grub_divmod64 (block_nr, nstripes - nparities, &stripen);
> >
> > This is clear...
> >
> >> +	      /*
> >> +	       * stripen is recomputed considering the parities (0 for A1, 1 for
> >> +	       * A2, 2 for A3....).
> >> +	       */
> >> +	      grub_divmod64 (high + stripen, nstripes, &stripen);
> >
> > ... but this looks strange... You add disk number to row number. Hmmm...
> > It looks that it works but this is not obvious at first sight. Could you
> > explain that?
>
> What about
> +	      /*
> +	       * stripen is recomputed considering the parities: different row have
> +              * a different offset, we have to add to stripen the number of row ("high") in
> +              * modulo nstripes (0 for A1, 1 for A2, 2 for A3....).
> +	       */

This is better but not much. You are repeating what code does.
I am especially interested in why this math is correct. It is not
obvious at first sight. If it is not it should be explained.
Otherwise we will forget in a few months why it is correct.

Daniel
