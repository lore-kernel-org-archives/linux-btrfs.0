Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA541ECDE3A
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5816B213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5816B213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbeJJCf6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:35:58 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52031 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbeJJCf6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 22:35:58 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1874675AbeJIR4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:56:43 +0200
Date:   Tue, 9 Oct 2018 19:56:43 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Message-ID: <20181009175643.GB11162@router-fw-old.i.net-space.pl>
References: <20180927183504.18078-1-kreijack@libero.it> <20180927183504.18078-5-kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927183504.18078-5-kreijack@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 27, 2018 at 08:34:59PM +0200, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
>
> Change the behavior of find_device(): before the patch, a read of a missed
> device may trigger a rescan. However, it is never recorded that a device
> is missed, so each single read of a missed device may triggers a rescan.
> It is the caller who decides if a rescan is performed in case of a missed
> device. And it does quite often, without considering if in the past a
> devices was already found as "missed"
> This behavior causes a lot of unneeded rescan, causing a huge slowdown in
> case of a missed device.
>
> After the patch, the "missed device" information is stored in the
> data->devices_attached[] array (as a NULL value in the field dev). A rescan
> is triggered only if no information at all is found. This means that only
> the first time a read of a missed device triggers a rescan.
>
> The change in the code is done removing "return NULL" when the disk is not
> found. So it is always executed the code which stores in the
> data->devices_attached[] array the value returned by grub_device_iterate():
> NULL if the device is missed, or a valid data otherwise.
>
> Signed-off-by: Goffredo Baroncelli <kreikack@inwind.it>

Commit message still begs for improvement. I will send you a proposal shortly.

Daniel
