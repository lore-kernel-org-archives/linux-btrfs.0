Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651F7C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 17:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355AB2075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 17:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfCMRln (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:41:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:54080 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726349AbfCMRln (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 13:41:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E46D2B16A;
        Wed, 13 Mar 2019 17:41:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 41C44DA875; Wed, 13 Mar 2019 18:42:57 +0100 (CET)
Date:   Wed, 13 Mar 2019 18:42:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH 2/2] btrfs: fix vanished compression property after
 failed set
Message-ID: <20190313174255.GF31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <1552455379-2311-1-git-send-email-anand.jain@oracle.com>
 <1552455379-2311-2-git-send-email-anand.jain@oracle.com>
 <60c3e0c1-52dd-5389-e244-c82776b214a1@oracle.com>
 <486f715a-df7b-f242-e78a-295c1102b485@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <486f715a-df7b-f242-e78a-295c1102b485@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 13, 2019 at 06:49:27PM +0800, Anand Jain wrote:
> 
> 
> On 3/13/19 6:33 PM, Anand Jain wrote:
> > 
> > 
> > 
> > On 3/13/19 1:36 PM, Anand Jain wrote:
> >> The compression property resets to NULL, instead of the old value if we
> >> fail to set the new compression parameter.
> >>
> >> btrfs prop get /btrfs compression
> >>    compression=lzo
> >> btrfs prop set /btrfs compression zli
> >>    ERROR: failed to set compression for /btrfs: Invalid argument
> >> btrfs prop get /btrfs compression
> >>
> >> This is because the compression property ->validate() is successful for
> >> 'zli' as the strncmp() used the len passed from the userland.
> >>
> >> Fix it by using the expected string length in strncmp().
> >>
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >> ---
> >>   fs/btrfs/props.c | 6 +++---
> >>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> >> index ef6502a94712..7aa362c2fbcf 100644
> >> --- a/fs/btrfs/props.c
> >> +++ b/fs/btrfs/props.c
> >> @@ -277,11 +277,11 @@ static int prop_compression_validate(struct 
> >> inode *inode, const char *value,
> >>       if (!value)
> >>           return 0;
> >> -    if (!strncmp("lzo", value, len))
> >> +    if (!strncmp("lzo", value, 3))
> >>           return 0;
> >> -    else if (!strncmp("zlib", value, len))
> >> +    else if (!strncmp("zlib", value, 4))
> >>           return 0;
> >> -    else if (!strncmp("zstd", value, len))
> >> +    else if (!strncmp("zstd", value, 4))
> >>           return 0;
> >>
> > 
> > 
> >    Nack.
> > Now some junk value after expected string is not an error.
> > such as..
> > 
> > btrfs prop set /btrfs compression lzo110
> 
>   mount(8) compression and the property compression parameter have
>   diverged, the compression levels are set able only from
>   mount(8) option? We should rather make it consistent?

Yes the properties should be able to get to the same result as the mount
option, but this needs more changes as the level is not extracted from
the property and passed to the compression (in compress_file_range).
