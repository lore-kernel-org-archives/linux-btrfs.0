Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF8FC6786F
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B2A920657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="fhbvfeUs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B2A920657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeKBELQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:11:16 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46285 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbeKBELP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:11:15 -0400
Received: by mail-qk1-f195.google.com with SMTP id q1so11275174qkf.13
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J5C/waXGsq2vYTurjfRKaECzyap/+LdHza4t1TGn7mw=;
        b=fhbvfeUsnceYR1ibbkWDh/xyJLem0XskCDvP0YKXyYYR8A1L3/fhBDyvGkwh9x2sQw
         tggXmwkR/c7wBAjIdiOM6lbtZgJ8X/xYkFWbTjIXQx/SZDIAESB9E52FqMoN+tQCfVhS
         KDwretNV/L3HOWDDM53cxFQFPqCSm0ZGEBGkODtxz9QkYTG5FoNrpjvXQoiYeaXXrpYK
         +kX12iBzmoVSnrbLpMmhXMoQCv2bLxpgdTVV3zKlJywnI6LfQXhUJth9PuXXBV4m+S6p
         KmZdhDfQk3khKxvAEZyBGVGdMR7PWPfaSyOQiZ7CzWTZKccjBgQcAmyASiFrGp3r5TRD
         uggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J5C/waXGsq2vYTurjfRKaECzyap/+LdHza4t1TGn7mw=;
        b=Lta2lvEHYi1o4gkdr00/CszdEM/trgRjaso2Fd3QwrVmooFbgkWCz4cu2c5Eg2FI8N
         I6/MG5EbauQ4URoja2ADRjOeZwB7zydrQXscnwtZb4VDtocw4nwoBzCJ5j3qQvG/MO66
         qvUlO4G05NFc80zL+NQwUbjNzSPtNkQM48ZGDbQgiNV7k5u0y8Y5k9gz2/zuiOIciwP1
         FVqxiEOCIIzHaTIL6tmCP8f2RDleYxkyk7JExwuthe3KHFwhB9i/cXOIPf1wcOgiR+5J
         YIMpQNkd6+uDyNvO2JdF/iZd57jiPMYU+gZ8/PXrqk+/blmepBzpAVjvuxNNM0h5Ovuz
         +Pkg==
X-Gm-Message-State: AGRZ1gK1OPmXhvijuC/oZNjSHfgnIc/RFGYwCbbjoD9Zg7DBT3z7JxeR
        QwgLOqLgccduUXtcs0typjRFhpQcrjLMWg==
X-Google-Smtp-Source: AJdET5chF1L61AVrGIOULSqcO+fZGKP3JgQTMY9eNwSIiRIzBhDmav0nMDg4aP1m0cJAEc3eHaD9iw==
X-Received: by 2002:a0c:f648:: with SMTP id s8mr8064382qvm.122.1541099220799;
        Thu, 01 Nov 2018 12:07:00 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id o63-v6sm10883908qka.16.2018.11.01.12.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:06:59 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:06:58 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] btrfs: Remove extent_io_ops::set_bit_hook extent_io
 callback
Message-ID: <20181101190657.xx5gecakrewbd6wt@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-6-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-6-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:50PM +0200, Nikolay Borisov wrote:
> This callback is used to properly account delalloc extents for
> data inodes (ordinary file inodes and freespace v1 inodes). Those can
> be easily identified since they have their extent_io trees
> ->private_data member point to the inode. Let's exploit this fact to
> remove the needless indirection through extent_io_hooks and directly
> call the function. Also give the function a name which reflects its
> purpose - btrfs_set_delalloc_extent.
> 
> This patch also modified test_find_delalloc so that the extent_io_tree
> used for testing doesn't have its ->private_data set which would have
> caused a crash in btrfs_set_delalloc_extent due to the
> btrfs_inode->root member not being initialised. The old version of the
> code also didn't call set_bit_hook since the extent_io ops weren't set
> for the inode.  No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
