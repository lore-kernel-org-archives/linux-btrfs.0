Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6090C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44EA721582
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44EA721582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbeI0Whu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 18:37:50 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:56598 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbeI0Whu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:37:50 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1871587AbeI0QSh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:18:37 +0200
Date:   Thu, 27 Sep 2018 18:18:37 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     kreijack@inwind.it
Cc:     Daniel Kiper <dkiper@net-space.pl>, grub-devel@gnu.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs: Add support for recovery for a RAID 5 btrfs profiles.
Message-ID: <20180927161837.GC22053@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-8-kreijack@libero.it> <20180925191032.GD30715@router-fw-old.i.net-space.pl> <e9cd180c-2cc4-e6e2-1b9c-00a3dd353097@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9cd180c-2cc4-e6e2-1b9c-00a3dd353097@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 09:55:57PM +0200, Goffredo Baroncelli wrote:
> On 25/09/2018 21.10, Daniel Kiper wrote:
> > On Wed, Sep 19, 2018 at 08:40:38PM +0200, Goffredo Baroncelli wrote:
> >> From: Goffredo Baroncelli <kreijack@inwind.it>
> >>
> >> Add support for recovery for a RAID 5 btrfs profile. In addition
> >> it is added some code as preparatory work for RAID 6 recovery code.
> >>
> >> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> >> ---
> >>  grub-core/fs/btrfs.c | 169 +++++++++++++++++++++++++++++++++++++++++--
> >>  1 file changed, 164 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> >> index 5c1ebae77..55a7eeffc 100644
> >> --- a/grub-core/fs/btrfs.c
> >> +++ b/grub-core/fs/btrfs.c
> >> @@ -29,6 +29,7 @@
> >>  #include <minilzo.h>
> >>  #include <grub/i18n.h>
> >>  #include <grub/btrfs.h>
> >> +#include <grub/crypto.h>
> >>
> >>  GRUB_MOD_LICENSE ("GPLv3+");
> >>
> >> @@ -665,6 +666,148 @@ btrfs_read_from_chunk (struct grub_btrfs_data *data,
> >>      return err;
> >>  }
> >>
> >> +struct raid56_buffer {
> >> +  void *buf;
> >> +  int  data_is_valid;
> >> +};
> >> +
> >> +static void
> >> +rebuild_raid5 (char *dest, struct raid56_buffer *buffers,
> >> +	       grub_uint64_t nstripes, grub_uint64_t csize)
> >> +{
> >> +  grub_uint64_t i;
> >> +  int first;
> >> +
> >> +  i = 0;
> >> +  while (buffers[i].data_is_valid && i < nstripes)
> >> +    ++i;
> >
> > for (i = 0; buffers[i].data_is_valid && i < nstripes; i++);
> >
> >> +  if (i == nstripes)
> >> +    {
> >> +      grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
> >> +      return;
> >> +    }
> >> +
> >> +  grub_dprintf ("btrfs", "rebuilding RAID 5 stripe #%" PRIuGRUB_UINT64_T "\n",
> >> +	        i);
> >
> > One line here please.
> >
> >> +  for (i = 0, first = 1; i < nstripes; i++)
> >> +    {
> >> +      if (!buffers[i].data_is_valid)
> >> +	continue;
> >> +
> >> +      if (first) {
> >> +	grub_memcpy(dest, buffers[i].buf, csize);
> >> +	first = 0;
> >> +      } else
> >> +	grub_crypto_xor (dest, dest, buffers[i].buf, csize);
> >> +
> >> +    }
> >
> > Hmmm... I think that this function can be simpler. You can drop first
> > while/for and "if (i == nstripes)". Then here:
> >
> > if (first) {
> >   grub_dprintf ("btrfs", "called rebuild_raid5(), but all disks are OK\n");
> >
> > Am I right?
>
> Ehm.. no. The "if" is an internal check to avoid BUG. rebuild_raid5() should be called only if some disk is missed.
> To perform this control, the code checks if all buffers are valid. Otherwise there is an internal BUG.

Something is wrong here. I think that the code checks if it is an invalid
buffer. If there is not then GRUB complains. Right? However, it looks
that I misread the code and made a mistake here. So, please ignore
this change. Though please change while() with for() at the beginning.

Daniel
