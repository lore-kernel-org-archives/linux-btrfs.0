Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BB4C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 18:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74B08218AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 18:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfAaSLJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 13:11:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:54226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfAaSLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:11:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1E759ACA8;
        Thu, 31 Jan 2019 18:11:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4FFC3DA7D6; Thu, 31 Jan 2019 19:10:32 +0100 (CET)
Date:   Thu, 31 Jan 2019 19:10:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH 11/11] btrfs: add zstd compression level support
Message-ID: <20190131181032.GM2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-12-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128212437.11597-12-dennis@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 28, 2019 at 04:24:37PM -0500, Dennis Zhou wrote:
>  static struct list_head *zstd_get_workspace(unsigned int level)
>  {
> -	struct list_head *ws = btrfs_get_workspace(&wsm, level);
> -	struct workspace *workspace = list_entry(ws, struct workspace, list);
> +	struct list_head *ws;
> +	unsigned long nofs_flag;

nofs_flag should be 'unsigned'
