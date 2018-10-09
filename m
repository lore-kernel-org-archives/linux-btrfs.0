Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68908FA3759
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB5C213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FB5C213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbeJJCgB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:36:01 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52031 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbeJJCgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 22:36:00 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1874688AbeJISYw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 20:24:52 +0200
Date:   Tue, 9 Oct 2018 20:24:52 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 9/9] btrfs: Add RAID 6 recovery for a btrfs filesystem.
Message-ID: <20181009182452.GD11162@router-fw-old.i.net-space.pl>
References: <20180927183504.18078-1-kreijack@libero.it> <20180927183504.18078-10-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927183504.18078-10-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 27, 2018 at 08:35:04PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Add the RAID 6 recovery, in order to use a RAID 6 filesystem even if some
> disks (up to two) are missing. This code use the md RAID 6 code already
> present in grub.
>
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

Daniel
