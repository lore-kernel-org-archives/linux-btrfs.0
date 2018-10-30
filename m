Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C25C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 19:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1884620657
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 19:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1884620657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727596AbeJaD6R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 23:58:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:37704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726532AbeJaD6R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 23:58:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 260A8AC38;
        Tue, 30 Oct 2018 19:03:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CBD42DAB9E; Tue, 30 Oct 2018 20:03:17 +0100 (CET)
Date:   Tue, 30 Oct 2018 20:03:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     clm@fb.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        jbacik@fb.com, dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH v3 10/10] btrfs: use common file type conversion
Message-ID: <20181030190317.GH9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Phillip Potter <phil@philpotter.co.uk>,
        clm@fb.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        jbacik@fb.com, dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181027005331.GA9924@pathfinder>
 <20181027005348.GA9996@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181027005348.GA9996@pathfinder>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Oct 27, 2018 at 01:53:48AM +0100, Phillip Potter wrote:
> Deduplicate the btrfs file type conversion implementation - file systems
> that use the same file types as defined by POSIX do not need to define
> their own versions and can use the common helper functions decared in
> fs_types.h and implemented in fs_types.c
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Acked-by: David Sterba <dsterba@suse.com>
