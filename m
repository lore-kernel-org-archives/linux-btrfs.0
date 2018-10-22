Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0A6C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 11:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B1D02087D
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 11:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B1D02087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbeJVTVJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 15:21:09 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:45895 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbeJVTVJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 15:21:09 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1876372AbeJVLCp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 13:02:45 +0200
Date:   Mon, 22 Oct 2018 13:02:45 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Message-ID: <20181022110245.GB12705@router-fw-old.i.net-space.pl>
References: <20181018175541.9532-1-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018175541.9532-1-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 07:55:32PM +0200, Goffredo Baroncelli wrote:
>
> Hi All,
>
> the aim of this patches set is to provide support for a BTRFS raid5/6
> filesystem in GRUB.
>
> The first patch, implements the basic support for raid5/6. I.e this works when
> all the disks are present.
>
> The next 5 patches, are preparatory ones.
>
> The 7th patch implements the raid5 recovery for btrfs (i.e. handling the
> disappearing of 1 disk).
> The 8th patch makes the code for handling the raid6 recovery more generic.
> The last one implements the raid6 recovery for btrfs (i.e. handling the
> disappearing up to two disks).
>
> I tested the code in grub-emu, and it works both with all the disks,
> and with some disks missing. I checked the crc32 calculated from grub and
> from linux and these matched. Finally I checked if the support for md raid6
> still works properly, and it does (with all drives and with up to 2 drives
> missing)
>
> Comments are welcome.

In general whole patch series LGTM. +/- some nit picks including changes
for patch #7. If you are OK with them and there are no objections then
I will apply the patches in a week or so.

Thank you for doing the work.

Daniel
