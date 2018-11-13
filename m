Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E06C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52346223C8
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52346223C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbeKNBUl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:20:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:53232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731211AbeKNBUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 20:20:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 13401B141;
        Tue, 13 Nov 2018 15:22:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3DFC4DAD3E; Tue, 13 Nov 2018 16:21:48 +0100 (CET)
Date:   Tue, 13 Nov 2018 16:21:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC RESEND] btrfs: harden agaist duplicate fsid
Message-ID: <20181113152147.GC24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1539571517-7900-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539571517-7900-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 10:45:17AM +0800, Anand Jain wrote:
> (Thanks for the comments on requiring to warn_on if we fail the device change.)
> (This fixes an ugly bug, I appreciate if you have any further comments).
> 
> Its not that impossible to imagine that a device OR a btrfs image is
> been copied just by using the dd or the cp command. Which in case both
> the copies of the btrfs will have the same fsid. If on the system with
> automount enabled, the copied FS gets scanned.
> 
> We have a known bug in btrfs, that we let the device path be changed
> after the device has been mounted. So using this loop hole the new
> copied device would appears as if its mounted immediately after its
> been copied.
> 
> For example:
> 
> Initially.. /dev/mmcblk0p4 is mounted as /
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part /
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> 
> btrfs fi show
>    Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>    Total devices 1 FS bytes used 1.40GiB
>    devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
> 
> Copy mmcblk0 to sda
>    dd if=/dev/mmcblk0 of=/dev/sda
> 
> And immediately after the copy completes the change in the device
> superblock is notified which the automount scans using
> btrfs device scan and the new device sda becomes the mounted root
> device.
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sda           8:0    1 14.9G  0 disk
> |-sda4        8:4    1    4G  0 part /
> |-sda2        8:2    1  500M  0 part
> |-sda3        8:3    1  256M  0 part
> `-sda1        8:1    1  256M  0 part
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> 
> btrfs fi show /
>  Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>  Total devices 1 FS bytes used 1.40GiB
>  devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
> 
> The bug is quite nasty that you can't either unmount /dev/sda4 or
> /dev/mmcblk0p4. And the problem does not get solved until you take
> sda out of the system on to another system to change its fsid
> using the 'btrfstune -u' command.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

I'm adding the patch to misc-next now, with an update message that
matches the format when a device is scanned.

"BTRFS: device fsid %pU devid %llu moved old:%s new:%s\n",

That way it should be possible to grep for all messages that are related
to the scanning ioctl.
