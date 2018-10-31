Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B6EC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 12:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BA72081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 12:06:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79BA72081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbeJaVEl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 17:04:41 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:33740 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbeJaVEl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 17:04:41 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1877753AbeJaMGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 13:06:23 +0100
Date:   Wed, 31 Oct 2018 13:06:23 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     Daniel Kiper <dkiper@net-space.pl>,
        Goffredo Baroncelli <kreijack@libero.it>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Message-ID: <20181031120623.GA13223@router-fw-old.i.net-space.pl>
References: <20181018175541.9532-1-kreijack@libero.it> <20181022110245.GB12705@router-fw-old.i.net-space.pl> <2F6AF0F1-DD4A-4406-9319-431CB1783BF5@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2F6AF0F1-DD4A-4406-9319-431CB1783BF5@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 07:49:40PM +0000, Nick Terrell wrote:
>
>
> > On Oct 22, 2018, at 4:02 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
> >
> > On Thu, Oct 18, 2018 at 07:55:32PM +0200, Goffredo Baroncelli wrote:
> >>
> >> Hi All,
> >>
> >> the aim of this patches set is to provide support for a BTRFS raid5/6
> >> filesystem in GRUB.
> >>
> >> The first patch, implements the basic support for raid5/6. I.e this works when
> >> all the disks are present.
> >>
> >> The next 5 patches, are preparatory ones.
> >>
> >> The 7th patch implements the raid5 recovery for btrfs (i.e. handling the
> >> disappearing of 1 disk).
> >> The 8th patch makes the code for handling the raid6 recovery more generic.
> >> The last one implements the raid6 recovery for btrfs (i.e. handling the
> >> disappearing up to two disks).
> >>
> >> I tested the code in grub-emu, and it works both with all the disks,
> >> and with some disks missing. I checked the crc32 calculated from grub and
> >> from linux and these matched. Finally I checked if the support for md raid6
> >> still works properly, and it does (with all drives and with up to 2 drives
> >> missing)
> >>
> >> Comments are welcome.
> >
> > In general whole patch series LGTM. +/- some nit picks including changes
> > for patch #7. If you are OK with them and there are no objections then
> > I will apply the patches in a week or so.
>
> Awesome! I'll look for the update and send an rebased version of the zstd
> patch set when it is out.

v11 pushed.

Goffredo, thank you for doing the work.

Nick, you can go ahead and rebase yours patchset.

Daniel
