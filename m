Return-Path: <SRS0=NX0b=ZS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9D8C43215
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 16:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015412082F
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 16:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKZQkF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:40:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:33814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727754AbfKZQkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 11:40:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58290B361;
        Tue, 26 Nov 2019 16:40:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A028ADA898; Tue, 26 Nov 2019 17:40:01 +0100 (CET)
Date:   Tue, 26 Nov 2019 17:40:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] btrfs: sysfs, rename device_link add,remove
 functions
Message-ID: <20191126164001.GJ2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1574328814-12263-1-git-send-email-anand.jain@oracle.com>
 <1574328814-12263-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574328814-12263-3-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 21, 2019 at 05:33:31PM +0800, Anand Jain wrote:
> In preparation to add btrfs_device::dev_state attribute in
>   /sys/fs/btrfs/UUID/devices/

But we don't want to add any attributes to that directory, is this some
leftover from the previous iterations?

> Rename btrfs_sysfs_add_device_link() and btrfs_sysfs_rm_device_link() to
> btrfs_sysfs_add_devices_attr() and btrfs_sysfs_remove_devices_attr() as
> these functions is going to create more attributes rather than just the
> link to the disk. No functional changes.

I think the function name matches what it does, it really links the
device.
