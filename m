Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99459C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 19:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27B3E204EC
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 19:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=zoho.com header.i=tprokott@zoho.com header.b="kImZgeEl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27B3E204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=zoho.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbeJXDq1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 23:46:27 -0400
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25487 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbeJXDq1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 23:46:27 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1540322500; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=YPxsXkRB+7w/fP1xScaaTphETDud4Ei10B6UdfciZ1UUnOf19mQjLrb4B5qgGA4iErx4dhVIKpP/ZMeeuDtS6UOSnZDaeM/nhKvk5RUsf6VQEAduURBUEAG2963g33ySiFH+nTerU3GyVflpHvhB64Dh0xZvtxKJ8cC6rS6Is0U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1540322500; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=PTxvcN6tDyqBDsqD9Ye5vJf5t4sx83/EL02isyor8A4=; 
        b=N0wHbgwjj/4WQyTJF2w5qRaqMNF6ybsp0dUH+SxAjOcszF/0uRzDM4J6R/pmHeyVSnybhTFh/fc2dNxNq2docB/+/NWKsMmAFQkRvPaq1edZaZHkivJW752R4ULKQCdT7zbNjvdR55msweee41i1+JMLsELPyoYeiQHyAzaFIvM=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=tprokott@zoho.com;
        dmarc=pass header.from=<tprokott@zoho.com> header.from=<tprokott@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=date:from:to:message-id:in-reply-to:references:subject:mime-version:content-type:user-agent; 
  b=HCx+0t2hm3VZ8UEUe3d06HSP2lxiZ5PQ7MSwy3BYFP+/nUczHc9qVBim50eGKAzCzCHImlMxtTRh
    nFlHXTgZ9WVpA1FjibmjEu+4MGoD9kQJTOCYqVeNn7lrz1RcePUr  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1540322500;
        s=default; d=zoho.com; i=tprokott@zoho.com;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=3493; bh=PTxvcN6tDyqBDsqD9Ye5vJf5t4sx83/EL02isyor8A4=;
        b=kImZgeEl+W5L3IX0etUOHAQ7AdDq3RbgpXEXtGP562Qk0HtfR7kWwaSFiY9PUHGz
        ZHsKWo8Vm0ZTvCZ7vmqvO/rVFRnY7SRu4HN8FiWTNbpwwc6G53nTX9qtjOXHTqBwuB0
        8mQ1cEj/xKLqLu/YOpPvGUDxL2srWSX5WB7aOp1k=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1540322499787149.02366506045223; Tue, 23 Oct 2018 12:21:39 -0700 (PDT)
Received: from  [24.7.203.165] by mail.zoho.com
        with HTTP;Tue, 23 Oct 2018 12:21:39 -0700 (PDT)
Date:   Tue, 23 Oct 2018 12:21:39 -0700
From:   Tony Prokott <tprokott@zoho.com>
To:     "linux-btrfs" <linux-btrfs@vger.kernel.org>
Message-ID: <166a2601cc9.1251c8f6b159383.1587614760796128824@zoho.com>
In-Reply-To: <ca04659e-0103-6698-6971-2a34f7cd929d@gmx.com>
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
 <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
 <16685d14644.eefe20a081666.8834845236508091976@zoho.com> <ca04659e-0103-6698-6971-2a34f7cd929d@gmx.com>
Subject: Re: Conversion to btrfs raid1 profile on added ext device renders
 some systems unable to boot into converted rootfs
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Priority: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The trouble is yet unresolved, symptoms are as they were, but I've diagnosed a step further. Maybe you can help me advance the diagnosis or better pose my question among debian experts, related to adjusting the building of initrd.

 ---- On Thu, 18 Oct 2018 00:08:08 -0700 Qu Wenruo <quwenruo.btrfs@gmx.com> wrote ---- 
 > >  > Still looks like a initramfs problem [rather] than btrfs problem.  
Yes, but linux-btrfs list still knows better than I how best to proceed, mainly how to distill the trouble description using proper terms, also lending broader understanding of what named modules serve what device activate&cfg or storage-access purpose.

 > >  > In the busybox environment, have you tried listing /dev to see if that external device is found?  
External usb attached drives are definitely not found by a newly launched kernel, and particulars of why are still not self evident. Boot loader grub2 all along still has no trouble accessing -- presumably it's not able to leverage raid1 redundancy in btrfs but does have access to the ext mirror device and takes notice in passing of matching UUID's.

 > By default, btrfs must see *all* devices to mount RAID1/10/5/6/0. Unless you're using "degraded" mount option. 
 > You could argue it's a bad decision, but still you have the choice. 
Yes did manage to mount it degraded, just to see that content demirrored is also unclobbered, however can't finish the job by such means; hopefully in the process no metadata or other junk was written unintentionally (forgot to mount readonly - degraded)

The task now seems to be finishing resolving which modules can bring in the rest of the critical infrastructure to allow access to the drives that had been no customized bother to bring online, prior to rootfs raid1 conversion. A recently found item of great interest is module "autofs4" which has userland friends such as systemd; it's present in cindy(LMDE3) which boots fine in spite of deriving from stretch, and was absent in stretch & buster which no longer boot.

 > > When manually trying to mount in busybox, it gives a similar error about missing the same external device, by its UUID_SUB 
 > Then it's still something wrong about the initramfs. From your description, it looks pretty like the lack of external disk driver is the root cause. 
Agreed *something* missing in initrd and-or module deployment is the cause of failing access to ext usb3 drive enclosure devices, but am still tracking down which other missing blobs may be of concern; since busybox won't allow "lsblk" "lshw" or "lsusb" -- only "blkid" or "ls /dev" work to detect devices -- my confidence and expediency in tracking is reduced; haven't yet happened upon the debian feature that lets more nonkernel programs and libraries--not just modules-- be built into initrd.

As an aside probably not germane, the grub.cfg "linux" line to load the kernel in some cases has "ro" readonly option and others not; what's the difference signify? How to make informed choice whether to use ro? Why mount a real disk rootfs without write access, before corruption's detected? Would that not potentially cripple some vital features such as logging?

So far it's clear that uas, usb_storage, & autofs4 may be built into initrd and then load ok, but they're not enough to restore normal systemd launch. Setting "MODULES=dep" in /etc/initramfs-tools/conf.d/driver-policy seems not smart enough for building in all necessary objects. Ideas welcome.

regards-
TP


