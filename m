Return-Path: <SRS0=h89n=3F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E59CC33CAF
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 18:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8E220663
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 18:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436977AbgAPSz6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:55:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:33658 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407310AbgAPSz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Jan 2020 13:55:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC87DB4D8;
        Thu, 16 Jan 2020 18:55:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BF229DA791; Thu, 16 Jan 2020 19:55:39 +0100 (CET)
Date:   Thu, 16 Jan 2020 19:55:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Michael Ruiz <michael@mruiz.dev>
Cc:     linux-btrfs@vger.kernel.org, osandov@fb.com
Subject: Re: Linux swap file not activating after reboot
Message-ID: <20200116185539.GZ3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Michael Ruiz <michael@mruiz.dev>,
        linux-btrfs@vger.kernel.org, osandov@fb.com
References: <5318295.DvuYhMxLoT@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5318295.DvuYhMxLoT@archlinux>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 15, 2020 at 04:34:02PM -0800, Michael Ruiz wrote:
> Hi,
>  I have a //@swap subvolume and i have a swapfile within it. I mount the 
> subvolume like such in fstab:
> 
> `rw,ssd,nofail,noautodefrag,nodatacow,nodatasum,subvolid=1234,subvol=/@swap`
> 
> It mounts correctly, but 1/15/20 4:20 PM kernel I get: 
> 
> `BTRFS warning (device dm-0): swapfile must not be copy-on-write`

There are two reasons why the message is printed, one is when the file
does not have the C attribute and another one when the the existing file
extents need to be COWed (same case as if the file is NOCOW and has been
snapshotted).

Plain reboot will not change the C attribute, so either there's a
snapshot of /@snap or the check of a used swapfile is wrong.

I tested it here, a swapfile that got almost full after a stress test,
followed by reboot and swapon (without any change to the file) was ok.

Doing a snapshot and swapon resulted in the message you saw.

After deleting the snapshot and waiting until it gets cleaned, swapon
did not activate the file anymore. Filefrag or fiemap don't report any
shared extents so here I' expect that the file should be in a valid
state for swapon.

Omar, any ideas?
