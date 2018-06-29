Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:38375 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934758AbeF2Mza (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 08:55:30 -0400
Message-ID: <c0f6da0fdd5e50569eae3ae6c5b200e686b94605.camel@scientia.net>
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Date: Fri, 29 Jun 2018 14:55:26 +0200
In-Reply-To: <530a3014-52a2-0e82-425c-7648abd86ac6@gmx.com>
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
         <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
         <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
         <43a3fb8f-d8a8-7e2f-a143-207bd3ba8c74@gmx.com>
         <236b95bb46abce6e40040765b24199169541a1d2.camel@scientia.net>
         <530a3014-52a2-0e82-425c-7648abd86ac6@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2018-06-29 at 09:10 +0800, Qu Wenruo wrote:
> Maybe it's the old mkfs causing the problem?
> Although mkfs.btrfs added device size alignment much earlier than
> kernel, it's still possible that the old mkfs doesn't handle the
> initial
> device and extra device (mkfs.btrfs will always create a temporary fs
> on
> the first device, then add all the other devices to the system) the
> same
> way.

Well who knows,.. at least now everything's fine again :-)

Thanks guys!

Chris.
