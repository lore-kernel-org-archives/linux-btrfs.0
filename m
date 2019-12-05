Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B813AC43603
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 15:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A49924652
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 15:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfLEPOg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 10:14:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:36962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725909AbfLEPOf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Dec 2019 10:14:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BB14AE52;
        Thu,  5 Dec 2019 15:14:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2346DA733; Thu,  5 Dec 2019 16:14:28 +0100 (CET)
Date:   Thu, 5 Dec 2019 16:14:28 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: sysfs, add devid/dev_state kobject and
 attribute
Message-ID: <20191205151428.GS2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20191205112706.8125-1-anand.jain@oracle.com>
 <20191205112706.8125-5-anand.jain@oracle.com>
 <20191205142148.GQ2734@twin.jikos.cz>
 <78560abd-7d85-c95d-ed76-7810b1d03789@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78560abd-7d85-c95d-ed76-7810b1d03789@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 05, 2019 at 10:38:15PM +0800, Anand Jain wrote:
> > So the values copy the device state macros, that's probably ok.
>   Yep.

Although, sysfs files should print one value per file, which makes sense
in many cases, so eg. missing should exist separately too for quick
checks for the most common device states. The dev_state reflects the
internal state and is likely useful only for debugging.

> >> +static ssize_t btrfs_sysfs_dev_state_show(struct kobject *kobj,
> >> +					  struct kobj_attribute *a, char *buf)
> >> +{
> >> +	struct btrfs_device *device = container_of(kobj, struct btrfs_device,
> >> +						   devid_kobj);
> >> +
> >> +	btrfs_dev_state_to_str(device, buf, PAGE_SIZE);
> > 
> > The device access is unprotected, you need at least RCU but that still
> > does not prevent from the device being freed by deletion.
> 
>   We need RCU let me fix. Device being deleted is fine, there
>   is nothing to lose, another directory lookup will show that
>   UUID/devinfo/<devid> is gone is the device is deleted.

The device can be gone from the list but the sysfs files can still
exist.

    CPU1                                   CPU2

btrfs_rm_device
                                        open file
  btrfs_sysfs_rm_device_link
    btrfs_free_device
      kfree(device)
                                        call read, access freed device

> > The
> > device_list_mutex is quite heavy and allowing a DoS by repeatedly
> > reading the file contents is not something we want to allow.
> > 
> 
>    Yes we don't have to use device_list_mutex here, as its read,
>    a refresh/re-read will refresh the dev_state.

The point is not to synchronize the device state values but the device
object itself.
