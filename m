Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A213FC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702522086D
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfARRFy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 12:05:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:60412 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727489AbfARRFy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 12:05:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EFBDAAA71;
        Fri, 18 Jan 2019 17:05:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DB4BFDA83D; Fri, 18 Jan 2019 18:05:20 +0100 (CET)
Date:   Fri, 18 Jan 2019 18:05:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/6] btrfs: rename btrfs_find_device_by_path()
Message-ID: <20190118170517.GB2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <1547739153-6916-4-git-send-email-anand.jain@oracle.com>
 <20190117155421.GW2900@twin.jikos.cz>
 <30537913-7f91-9bea-81ce-c9e40b467412@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30537913-7f91-9bea-81ce-c9e40b467412@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 02:13:19PM +0800, Anand Jain wrote:
> On 01/17/2019 11:54 PM, David Sterba wrote:
> > On Thu, Jan 17, 2019 at 11:32:30PM +0800, Anand Jain wrote:
> >> btrfs_find_device_by_path() is a helper function, drop the btrfs prefix
> >> and the suffix _path is too generic, in fact as it reads superblock to
> >> find the btrfs_device, so rename it to find_device_by_superblock()
> > 
> > The function takes a path so it's search by path, as the name says, I
> > don't think that needs to change.
> 
>   Sorry I didn't mention about my motivation to rename..
>   find device by matching the device_path (without reading its
>   superblock) is done by btrfs_free_stale_devices() and its helper
>   device_path_matched() in the patch [1] which is in next-dev.
> 
>   [1]
>   btrfs: refactor btrfs_free_stale_devices() to get return value
> 
>   So a reader can think why not use btrfs_find_device_by_path() here,
>   unless fn is read to find out it matches the device by taking
>   the devid from the superblock.

That would be really unfortunate to conflate a simple short helper that
really wraps strcmp with a function doing a lot of other things. With
source code at hand we don't have to speculate from a function name what
it does, we go and read it if not sure.

>   Its not a big deal though.. I am ok to keep this as it is.. or... more
>   below..
> 
> > And even this is a helper, the
> > btrfs_ prefix is useful in case there's something stuck inside the
> > block layer functions that get called later so it's obvious on the
> > stack.
> 
>   Makes sense.
> 
>   Or.
>   I think its a good idea to collapse this relatively small function into
>   its only parent, btrfs_find_device_by_devspec().

Devspec is either device id or the path, so the _devspec is a switch to
two ways how to find the device and merging the the helper code does not
seem to improve code.

Sorry I really fail to see the point of this patch and the code issues
it's supposed to resolve.
