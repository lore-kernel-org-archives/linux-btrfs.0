Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34430 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932139AbdEQSYD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 14:24:03 -0400
Received: by mail-wm0-f66.google.com with SMTP id d127so5480665wmf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 11:23:57 -0700 (PDT)
From: Kai Krakow <kai@kaishome.de>
Date: Wed, 17 May 2017 20:23:55 +0200
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, fdmanana@suse.com, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem
 by X hours?
Message-ID: <20170517202355.2a48bf72@jupiter.sol.local>
In-Reply-To: <20170505154323.hx6ht7jo5mnl6mye@merlins.org>
References: <20170505024041.4jdfponlichetnwm@merlins.org>
        <54c51818-c46d-91de-19fd-d165b2d88ecb@cn.fujitsu.com>
        <20170505154323.hx6ht7jo5mnl6mye@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 5 May 2017 08:43:23 -0700
schrieb Marc MERLIN <marc@merlins.org>:

[missing quote of the command]
> > Corrupted blocks are corrupted, that command is just trying to
> > corrupt it again.
> > It won't do the black magic to adjust tree blocks to avoid them.  
>  
> I see. you may hve seen the earlier message from Kai Krakow who was
> able to to recover his FS by trying this trick, but I understand it
> can't work in all cases.

Huh, what trick? I don't take credit for it... ;-)

The corrupt-block trick must've been someone else...


-- 
Regards,
Kai

Replies to list-only preferred.
