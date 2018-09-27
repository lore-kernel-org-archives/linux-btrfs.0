Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1840C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B61F21582
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:21:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B61F21582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbeI0WkW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 18:40:22 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:56606 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbeI0WkW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:40:22 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1871593AbeI0QUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:20:38 +0200
Date:   Thu, 27 Sep 2018 18:20:38 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     kreijack@inwind.it
Cc:     Daniel Kiper <dkiper@net-space.pl>, grub-devel@gnu.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
Message-ID: <20180927162038.GD22053@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-10-kreijack@libero.it> <20180925192046.GE30715@router-fw-old.i.net-space.pl> <36e9e14c-f694-1d22-34bf-4a28b6c189cd@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36e9e14c-f694-1d22-34bf-4a28b6c189cd@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 09:56:07PM +0200, Goffredo Baroncelli wrote:
> On 25/09/2018 21.20, Daniel Kiper wrote:
> > On Wed, Sep 19, 2018 at 08:40:40PM +0200, Goffredo Baroncelli wrote:
> >> From: Goffredo Baroncelli <kreijack@inwind.it>
> >>
> [....]
> >>  	       *  - stripe_offset is the disk offset,
> >>  	       *  - csize is the "potential" data to read. It will be reduced to
> >>  	       *    size if the latter is smaller.
> >> +	       *  - parities_pos is the position of the parity inside a row (
> >
> > s/inside/in/>
> >> +	       *    2 for P1, 3 for P2...)
>
> +              *  - nparities is the number of parities (1 for RAID5, 2 for RAID6);
> +              *    used only in RAID5/6 code.
>
> >>  	       */
> >>  	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
> >>
> >> @@ -1030,6 +1069,9 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
> >>  	       */
> >>  	      grub_divmod64 (high + stripen, nstripes, &stripen);
> >>
> >> +	      grub_divmod64 (high + nstripes - nparities, nstripes,
> >> +			     &parities_pos);
> >
> > I think that this math requires a bit of explanation in the comment
> > before grub_divmod64(). Especially I am interested in why high +
> > nstripes - nparities works as expected.
>
>
> What about
>
> /*
>  * parities_pos is equal to "(high - nparities) % nstripes" (see the diagram above).
>  * However "high - nparities" might be negative (eg when high == 0) leading to an
>  * incorrect computation.
>  * Instead "high + nstripes - nparities" is always positive and in modulo nstripes is
>  * equal to "(high - nparities) % nstripes
>  */

LGTM.

Daniel
