Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEECC433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 11:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4C862078D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591874455;
	bh=0+sxtBect72jPqO+rq641H6d/+ec4oVrijKYw9rAwo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=p6X9iS2cR/Dlm/OrMZzofoCzkhxJaQynxI7s7MEBd5/cBwMqQ9gd/kCv5/Z71c0/2
	 yq2svLDKRCeLlmDIR0G1kxgw375NYXFyDcn/3kIjgUxO4UltuKU8lTCXihyb4weB9g
	 k85FcObya+9DXjGTz2sAgcZGgmVX2bWo0sOwVHXM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgFKLUg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 07:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgFKLUf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 07:20:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF622078D;
        Thu, 11 Jun 2020 11:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874433;
        bh=0+sxtBect72jPqO+rq641H6d/+ec4oVrijKYw9rAwo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dCcT0jSPypweAOdofLdfgp2pOpmONzVnSW9dyk2kGe1bYIp7OWl4/97f6iD4a2Cql
         B1T5zVmzFd7/toMVNoMgVCll0xC4ubCB/z8JdeTauCsDa9YSbfaV6OI1qtuWtqM51N
         GgP57QNq8vl3kaebrObZaGsXGqN8Un/7ssRmkiWY=
Date:   Thu, 11 Jun 2020 13:20:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vikash Bansal <bvikas@vmware.com>
Cc:     stable@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        anishs@vmware.com, vsirnapalli@vmware.com, akaher@vmware.com,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        anand.jain@oracle.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.19.y 0/2] btrfs: Fix for CVE-2019-18885
Message-ID: <20200611112027.GJ3802953@kroah.com>
References: <20200609065018.26378-1-bvikas@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609065018.26378-1-bvikas@vmware.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 09, 2020 at 12:20:16PM +0530, Vikash Bansal wrote:
> CVE Description:
> NVD Site Link: https://nvd.nist.gov/vuln/detail?vulnId=CVE-2019-18885
> 
> It was discovered that the btrfs file system in the Linux kernel did not
> properly validate metadata, leading to a NULL pointer dereference. An
> attacker could use this to specially craft a file system image that, when
> mounted, could cause a denial of service (system crash).
> 
> [PATCH v4.19.y 1/2]:
> Backporting of upsream commit 09ba3bc9dd15:
> btrfs: merge btrfs_find_device and find_device
> 
> [PATCH v4.19.y 2/2]:
> Backporting of upstream commit 62fdaa52a3d0:
> btrfs: Detect unbalanced tree with empty leaf before crashing
> 
> On NVD site link of "commit 09ba3bc9dd150457c506e4661380a6183af651c1" 
> was given as the fix for this CVE. But the issue was still reproducible.
> So had to apply patch "Commit 62fdaa52a3d00a875da771719b6dc537ca79fce1"
> to fix the issue.

Looks good, now queued up,t hanks.

greg k-h
