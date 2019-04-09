Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36BEC10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 15:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81D352084C
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 15:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfDIPre (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:47:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:54862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726431AbfDIPre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 11:47:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F385AFFA;
        Tue,  9 Apr 2019 15:47:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7328FDA88B; Tue,  9 Apr 2019 17:48:40 +0200 (CEST)
Date:   Tue, 9 Apr 2019 17:48:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] readmirror feature
Message-ID: <20190409154840.GM29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 06:00:19PM +0800, Anand Jain wrote:
> RFC patch as of now, appreciate your comments. This patch set has
> been tested.
> 
> Function call chain  __btrfs_map_block()->find_live_mirror() uses
> thread pid to determine the %mirror_num when the mirror_num=0.
>     
> The pid based mirror_num extrapolation has following disadvantages
>  . A large single-process read IO will read only from one disk.

Please note that the pid refers to the metadata kernel threads that
submit the IO, so on average the IO is serviced by different threads
with random PID. In the end it gets distributed over multiple drives.
But it's nott ideal, no argument about that.

>  . In a worst scenario all processes read accessing the FS could have
>        either odd or even pid, the read IO gets skewed.
>  . There is no deterministic way of knowing/controlling which copy will
>        be used for reading.
>  . May see performance variations for a given set of multi process
>        workload ran at different times.
>     
> So we need other types of readmirror policies.
>     
> This patch introduces a framework so that we can add more policies, and
> converts the existing %pid into as a configurable parameter using the
> property. And also provides a transient readmirror mount option, so that
> this property can be applied for the read io during mount and for
> readonly FS.

I think the mirror selection by pid was a temporary solution (that
stuck, as it always happens). On average it does not work bad. Once we
have a better way then it can be dropped. So I'm not convinced it needs
to be one of the configuration options.

What exactly do you mean by 'transient'? I see that it could be needed
for mount or read-only, though I don't see the usefulness of that.

>  For example:
>    btrfs property set <mnt> readmirror pid
>    btrfs property set <mnt> readmirror ""
>    btrfs property set <mnt> readmirror devid<n>
> 
>    mount -o readmirror=pid <mnt>
>    mount -o readmirror=devid<n> <mnt>
> 
> Please note:
>  The property storage is an extented attributes of root inode
>  (BTRFS_FS_TREE_OBJECTID), the other choice is a new ondisk KEY,
>  which is open for comments.

A new key type is not going to be allocated for that, the extended
attributes for properties are there. Another question is where to attach
the property as this is a whole-filesystem property, we don't have an
example to follow so far.

>  This patch uses the unused btrfs_device::type, and does not use the
>  bitwise ops because as type is u64 and bitwise ops need u32, so we
>  need 32bits of the btrfs_device::type. Which is a kind of messy.
>  Its open for suggestion for any better way.

For a prototype and early testing, using the type is probably ok, but
I don't think it's right for permanent storage. Besides I'm sure that
the u64 will not suffice in the long run.
