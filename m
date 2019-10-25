Return-Path: <SRS0=FriU=YS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00F7CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0FA621D7F
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395479AbfJYPmN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:42:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:46336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730508AbfJYPmN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Oct 2019 11:42:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 995DFB291;
        Fri, 25 Oct 2019 15:42:11 +0000 (UTC)
Message-ID: <06601cbe64c98b2a9f0fa13a4e00401ae5d4387b.camel@suse.de>
Subject: Re: [PATCH 5/5] btrfs: ioctl: Call btrfs_vol_uevent on subvolume
 deletion
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Graham Cobb <g.btrfs@cobb.uk.net>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, mpdesouza@suse.com
Date:   Fri, 25 Oct 2019 12:44:20 -0300
In-Reply-To: <dcfbad52-6e5b-a9cc-e1a7-6b3db8e26e7c@cobb.uk.net>
References: <20191024023636.21124-1-marcos.souza.org@gmail.com>
         <20191024023636.21124-6-marcos.souza.org@gmail.com>
         <dcfbad52-6e5b-a9cc-e1a7-6b3db8e26e7c@cobb.uk.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 2019-10-25 at 13:00 +0100, Graham Cobb wrote:
> On 24/10/2019 03:36, Marcos Paulo de Souza wrote:
> > From: Marcos Paulo de Souza <mpdesouza@suse.com>
> > 
> > Since the function btrfs_ioctl_snap_destroy is used for deleting
> both
> > subvolumes and snapshots it was needed call btrfs_is_snapshot,
> > which checks a giver btrfs_root and returns true if it's a
> snapshot.
> > The current code is interested in subvolumes only.
> 
> To me, as a user, a snapshot *is* a subvolume. I don't even know what
> "is a snapshot" means. Does it mean "was created using the btrfs
> subvolume snapshot command"? Does it matter whether the snapshot has
> been modified? Whether the originally snapshot subvolume still
> exists?
> Or what?
> 
> I note that the man page for "btrfs subvolume" says "A snapshot is a
> subvolume like any other, with given initial content.". And I
> certainly
> have some subvolumes which are being used as normal parts of the
> filesystem, which were originally created as snapshots (for various
> reasons, including reverting changes and going back to an earlier
> snapshot, or an easy way to make sure that large common files are
> actually sharing blocks).

Agreed.

> 
> I would expect this event would be generated for any subvolume
> deletion.
> If it is useful to distinguish subvolumes originally created as
> snapshots in some way then export another flag (named to make it
> clear
> what it really indicates, such as BTRFS_VOL_FROM_SNAPSHOT). I don't
> know
> your particular purpose, but my guess is that a more useful flag
> might
> actually be BTRFS_VOL_FROM_READONLY_SNAPSHOT.

As soon as these patches got merged I will send new ones to take care
of snapshoting. Same things: when a snapsoht is created or removed,
send a uevent.

I liked this idea to separate both snapshots and volumes at first to
make things simpler, and get reviews faster. Also, I think it's good to
separate subvolumes and snapshot events, makes easier for one to filter
such events.

  Marcos

> 
> Graham

