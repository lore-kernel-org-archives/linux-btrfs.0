Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCE9C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 17:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D3872075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 17:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfCMRh5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:37:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:53584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbfCMRh4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 13:37:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AD10FAF98;
        Wed, 13 Mar 2019 17:37:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 83086DA875; Wed, 13 Mar 2019 18:39:10 +0100 (CET)
Date:   Wed, 13 Mar 2019 18:39:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix vanished compression property after
 failed set
Message-ID: <20190313173909.GE31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
 <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
 <4ef1a9bb-141c-c07b-d995-9ac3d0c8f1d2@suse.com>
 <90b86c08-7c3b-d0b1-a895-ebc45af4c059@suse.com>
 <ff110534-776d-738f-bb11-61233cfcd02e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff110534-776d-738f-bb11-61233cfcd02e@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 13, 2019 at 04:49:54PM +0800, Anand Jain wrote:
> 
> 
> On 3/13/19 3:22 PM, Nikolay Borisov wrote:
> > 
> > 
> > On 13.03.19 г. 9:20 ч., Nikolay Borisov wrote:
> >>
> >>
> >> On 13.03.19 г. 7:36 ч., Anand Jain wrote:
> >>> The compression property resets to NULL, instead of the old value if we
> >>> fail to set the new compression parameter.
> >>>
> >>> btrfs prop get /btrfs compression
> >>>    compression=lzo
> >>> btrfs prop set /btrfs compression zli
> >>>    ERROR: failed to set compression for /btrfs: Invalid argument
> >>> btrfs prop get /btrfs compression
> >>>
> >>> This is because the compression property ->validate() is successful for
> >>> 'zli' as the strncmp() used the len passed from the userland.
> >>>
> >>> Fix it by using the expected string length in strncmp().
> >>>
> >>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >>> ---
> >>>   fs/btrfs/props.c | 6 +++---
> >>>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> >>> index ef6502a94712..7aa362c2fbcf 100644
> >>> --- a/fs/btrfs/props.c
> >>> +++ b/fs/btrfs/props.c
> >>> @@ -277,11 +277,11 @@ static int prop_compression_validate(struct inode *inode, const char *value,
> >>>   	if (!value)
> >>>   		return 0;
> >>>   
> >>> -	if (!strncmp("lzo", value, len))
> >>> +	if (!strncmp("lzo", value, 3))
> >>>   		return 0;
> >>> -	else if (!strncmp("zlib", value, len))
> >>> +	else if (!strncmp("zlib", value, 4))
> >>>   		return 0;
> >>> -	else if (!strncmp("zstd", value, len))
> >>> +	else if (!strncmp("zstd", value, 4))
> >>>   		return 0;
> >>
> >> This also makes the len argument to prop_compression_validate redundant
> >> and should be removed as well.
> 
>   Its part of the 'struct prop_handler', its better to keep it until
>   properties have completely evolved.
> 
> > 
> > As a matter of fact I don't see any value in prop_compression_validate
> > since the exact same code is used in prop_compression_apply and einval
> > will be returned if an invalid value is passed in.
> 
>   I notice too. But its better to keep it until the most of the
>   properties have evolved.
> 
>   As of now btrfs_set_prop() follows sequence..
>     h->validate(prop)
>     setxattr(prop)
>     h->apply(prop)
> 
>   If validate fails its easy to fail exit.

Agreed, some code could be repeated in the apply() callback, but
otherwise I'd like to keep both.
