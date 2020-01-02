Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11388C2D0C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 19:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E665221655
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 19:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgABTAy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 14:00:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:36274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727951AbgABTAx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jan 2020 14:00:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 61279AC81;
        Thu,  2 Jan 2020 19:00:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81722DA735; Thu,  2 Jan 2020 20:00:43 +0100 (CET)
Date:   Thu, 2 Jan 2020 20:00:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs-progs: add support for LOGICAL_INO_V2 features
 in logical-resolve
Message-ID: <20200102190041.GR3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs@vger.kernel.org
References: <20191127035509.15011-1-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127035509.15011-1-ce3g8jdj@umail.furryterror.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 26, 2019 at 10:55:03PM -0500, Zygo Blaxell wrote:
> This patch set adds support for LOGICAL_INO_V2 features:
> 
>         - bigger buffer size (16M instead of 64K, default also increased to 64K)
> 
>         - IGNORE_OFFSETS flag to look up references by extent instead of block
> 
> If the V2 options are used, it calls the V2 ioctl; otherwise, it calls
> the V1 ioctl for old kernel compatibility.

Thanks, I've added the patchset to devel.
