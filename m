Return-Path: <SRS0=PX3t=BX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92F4C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 07:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B369220771
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 07:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgHMHjs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 03:39:48 -0400
Received: from rin.romanrm.net ([51.158.148.128]:47522 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgHMHjs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Aug 2020 03:39:48 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 582C3426;
        Thu, 13 Aug 2020 07:39:46 +0000 (UTC)
Date:   Thu, 13 Aug 2020 12:39:46 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Marc MERLIN <marc@merlins.org>
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: 5.6 pretty massive unexplained btrfs corruption:  parent
 transid verify failed + open_ctree failed
Message-ID: <20200813123946.5841d146@natsu>
In-Reply-To: <20200812223433.GA533@merlins.org>
References: <20200707035530.GP30660@merlins.org>
        <20200708034407.GE10769@hungrycats.org>
        <20200812223433.GA533@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 12 Aug 2020 15:34:33 -0700
Marc MERLIN <marc@merlins.org> wrote:

> Because it's an external array, I do stop it to save power and do this:
> umount /dev/mapper/crypt_bcache0
> sync
> dmsetup remove crypt_bcache0
> echo 1 > /sys/block/md6/bcache/stop
> mdadm --stop /dev/md6
> /etc/init.d/smartmontools stop
> sleep 5
> pdu disk3 off  <= cuts power
> 
> Note that I umount, then sync just in case, then a bunch of stuff to
> free up block devices, but by then the btrfs FS has been unmounted and
> synced.

Or should have been. If it's a copy-paste from a shell script (unless you do
the whole process manually every time), it doesn't appear like you check the
success status of each line before continuing to the next. Either add
"|| exit 1" to each of these that can fail, or just use "#!/bin/bash -e" in
the script's first line.

As is, imagine umount fails ("target busy"), then dmsetup fails ("device in
use"), then mdadm fails to stop the array, but then you cut power to the
entire thing anyways.

-- 
With respect,
Roman
