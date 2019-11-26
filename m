Return-Path: <SRS0=NX0b=ZS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6237FC432C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 16:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B19A20862
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Nov 2019 16:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfKZQzM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:55:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:45260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728731AbfKZQy5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 11:54:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34906B3ED;
        Tue, 26 Nov 2019 16:54:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8A41CDA898; Tue, 26 Nov 2019 17:54:54 +0100 (CET)
Date:   Tue, 26 Nov 2019 17:54:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs: sysfs, cleanups
Message-ID: <20191126165454.GM2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1574328814-12263-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574328814-12263-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 21, 2019 at 05:33:29PM +0800, Anand Jain wrote:
> v2:
>   In v2 I have used better naming compared to v1. For example
>   btrfs_fs_devices::devices_dir_kobj vs btrfs_fs_devices::devices_kobj
>   and btrfs_sysfs_add_device_info() vs btrfs_sysfs_add_devices_attr,
>   as I am following a pattern that sysfs directories are inherently
>   kobjects, which holds files as attributes. We could drop sysfs prefix
>   also because kobj and attr already indicate that they are part of
>   sysfs. But people not familiar with sysfs terminology might have to
>   wonder a little bit, so didn't make that bold changes.

I think the _sysfs_ part of the function is a good thing and makes it
clear that it belongs to the sysfs interfacing wrappers.

> Anand Jain (5):
>   btrfs: sysfs, rename devices kobject holder to devices_kobj
>   btrfs: sysfs, rename device_link add,remove functions
>   btrfs: sysfs, btrfs_sysfs_add_fsid() drop unused argument parent
>   btrfs: sysfs, rename btrfs_sysfs_add_device()
>   btrfs: sysfs, merge btrfs_sysfs_add devices_kobj and fsid

1,3,4,5 applied, thanks.
