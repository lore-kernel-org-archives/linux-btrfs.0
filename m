Return-Path: <SRS0=z0ck=YD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715A6C4360C
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 21:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4258C206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 21:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfJJVVh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:21:37 -0400
Received: from smtp01.belwue.de ([129.143.71.86]:58539 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbfJJVVh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Oct 2019 17:21:37 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id EB6959404
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2019 23:21:33 +0200 (MEST)
Date:   Thu, 10 Oct 2019 23:21:33 +0200
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: rsync -ax and subvolumes
Message-ID: <20191010212133.GA3648@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20191010172011.GA3392@tik.uni-stuttgart.de>
 <CAMthOuMV7MgB4b87RsijYr9e0UsjMUDNk+QRXeauFdb3cZcTjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMthOuMV7MgB4b87RsijYr9e0UsjMUDNk+QRXeauFdb3cZcTjw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu 2019-10-10 (20:47), Kai Krakow wrote:

> > I run into the problem that "rsync -ax" sees btrfs subvolumes as "other
> > filesystems" and ignores them.
> 
> I worked around it by mounting the btrfs-pool at a special directory:
> 
> mount -o subvolid=0 /dev/disk/by-label/rootfs /mnt/btrfs-pool

This is only possible by root, but not by regular users.
Yes, there are true multi-user systems still out there :-)


> Actually, you could also just bind-mount into /mnt/btrfs, bind-mounts
> won't inherit other mounts but will still see pure subvolumes.

Again, only possible by root.

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<CAMthOuMV7MgB4b87RsijYr9e0UsjMUDNk+QRXeauFdb3cZcTjw@mail.gmail.com>
