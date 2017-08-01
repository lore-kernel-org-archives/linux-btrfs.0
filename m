Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:45294 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbdHAGEN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 02:04:13 -0400
Date: Tue, 1 Aug 2017 11:04:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "marcel.cochem" <marcel.cochem@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error: bad tree block start 0 623771648
Message-ID: <20170801110410.0813a03a@natsu>
In-Reply-To: <20170731181200.GA3459@lim.localdomain>
References: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
        <20170731181200.GA3459@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 31 Jul 2017 11:12:01 -0700
Liu Bo <bo.li.liu@oracle.com> wrote:

> Superblock and chunk tree root is OK, looks like the header part of
> the tree root is now all-zero, but I'm unable to think of a btrfs bug
> which can lead to that (if there is, it is a serious enough one)

I see that the FS is being mounted with "discard". So maybe it was a TRIM gone
bad (wrong location or in a wrong sequence).

Generally it appears to be not recommended to use "discard" by now (because of
its performance impact, and maybe possible issues like this), instead schedule
to call "fstrim <mountpoint>" once a day or so, and/or on boot-up.

> on ssd like disks, by default there is only one copy for metadata.

Time and time again, the default of "single" metadata for SSD is a terrible
idea. Most likely DUP metadata would save the FS in this case.

-- 
With respect,
Roman
