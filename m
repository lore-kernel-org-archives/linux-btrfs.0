Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BA5C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10FFC20815
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:32:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10FFC20815
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbeKNBap (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:30:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:56394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728818AbeKNBao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 20:30:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 949EBB11F;
        Tue, 13 Nov 2018 15:32:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 95895DAD3E; Tue, 13 Nov 2018 16:31:50 +0100 (CET)
Date:   Tue, 13 Nov 2018 16:31:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: harden agaist duplicate fsid
Message-ID: <20181113153149.GD24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
 <98cd974b-d817-c30b-5cd7-d69214f44f39@gmail.com>
 <d209b853-4c15-4ef6-58b5-e1b08d409aeb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d209b853-4c15-4ef6-58b5-e1b08d409aeb@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 09:31:04PM +0800, Anand Jain wrote:
> >> +        /*
> >> +         * we are going to replace the device path, make sure its the
> >> +         * same device if the device mounted
> >> +         */
> >> +        if (device->bdev) {
> >> +            struct block_device *path_bdev;
> >> +
> >> +            path_bdev = lookup_bdev(path);
> >> +            if (IS_ERR(path_bdev)) {
> >> +                mutex_unlock(&fs_devices->device_list_mutex);
> >> +                return ERR_CAST(path_bdev);
> >> +            }
> >> +
> >> +            if (device->bdev != path_bdev) {
> >> +                bdput(path_bdev);
> >> +                mutex_unlock(&fs_devices->device_list_mutex);
> >> +                return ERR_PTR(-EEXIST);
> > It would be _really_ nice to have an informative error message printed 
> > here.  Aside from the possibility of an admin accidentally making a 
> > block-level copy of the volume, 
> 
> > this code triggering could represent an 
> > attempted attack against the system, so it's arguably something that 
> > should be reported as happening.
> 
> >  Personally, I think a WARN_ON_ONCE for 
> > this would make sense, ideally per-volume if possible.
> 
>   Ah. Will add an warn. Thanks, Anand

The requested error message is not in the patch you posted or I have
missed that (https://patchwork.kernel.org/patch/10641041/) .

Austin, is the following ok for you?

  "BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n"

  BTRFS: duplicate device fsid:devid 7c667b96-59eb-43ad-9ae9-c878f6ad51d8:2 old:/dev/sda6 new:/dev/sdb6

As the UUID and paths are long I tried to squeeeze the rest so it's
still comprehensible but this would be better confirmed. Thanks.
