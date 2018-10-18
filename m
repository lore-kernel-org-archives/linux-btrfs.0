Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2848ECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 06:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6337821476
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 06:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=zoho.com header.i=tprokott@zoho.com header.b="qQAcN+J1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6337821476
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=zoho.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbeJROPo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 10:15:44 -0400
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25424 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbeJROPn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 10:15:43 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1539843378; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=cjBghqP9f7SjFCiNNOo0hRBvDbdwX2AJBCRFzRBjSgCZYz9ly4Da5hhetDb4YJwnEXxIwOIyR/fa27BcHr+hAu26OLNp5z6l4WPxZnfFYoEmL575ZiiWzPJ8NJMVVeRw8+U6kT973P2/inZBC21xlF6+3SbKJ/5KTCIO/M8xaCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1539843378; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=oF7wfLLHBG5VD2JB19iSkl+54SmW4YBPYBqwoB53vd4=; 
        b=N7pfDM36iDHkou8KyHQwhMqOg6B3biAuertmBOsV8+2lznupSUsf0jVbLDvmlKzL+LVV/a1HU1gLV61JJk29q4MXRVNGxYorJdUEX0QtHtrm871eiPItsB8X3lwQNlXdsbv/lY06GWrVMpWiO+u8YYay0Ev0xJ+QvBKePBnr9Tk=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=tprokott@zoho.com;
        dmarc=pass header.from=<tprokott@zoho.com> header.from=<tprokott@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=date:from:to:message-id:in-reply-to:references:subject:mime-version:content-type:user-agent; 
  b=GTgILvXr9v4MruVPH90WPBLovTdLBo3eSH3Kn98NORhQTjx5k+fZiid6osewpJTJsl86QRHPrwFC
    radiEODrGfYgwdl8kKxK1fi1B6sCWf2SgXQsg1Ff/LFI4FT3Hyec  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1539843378;
        s=default; d=zoho.com; i=tprokott@zoho.com;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=2285; bh=oF7wfLLHBG5VD2JB19iSkl+54SmW4YBPYBqwoB53vd4=;
        b=qQAcN+J1KNoXTTVujZxmxKzk7l1OdaVBrVQgF4YX1DZ5lSovbEMGvq7XZRfjcVN8
        w67/EgX1cIek5NBp9VzwmTeTwvbyePJQeNL7QmSQnFZXcTmHM9i6iZlxNQg/xNmOVMf
        A/z+KwLx/N8L06nuuQSMQsiW/y7iWTSXDuvf0yNQ=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1539843376711390.8874159841138; Wed, 17 Oct 2018 23:16:16 -0700 (PDT)
Received: from  [24.7.203.165] by mail.zoho.com
        with HTTP;Wed, 17 Oct 2018 23:16:16 -0700 (PDT)
Date:   Wed, 17 Oct 2018 23:16:16 -0700
From:   Tony Prokott <tprokott@zoho.com>
To:     "linux-btrfs" <linux-btrfs@vger.kernel.org>
Message-ID: <16685d14644.eefe20a081666.8834845236508091976@zoho.com>
In-Reply-To: <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
References: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com> <9655303c-d4e9-cdbd-6d8c-8c9db3f05246@gmx.com>
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

 ---- On Wed, 17 Oct 2018 17:57:25 -0700 Qu Wenruo <quwenruo.btrfs@gmx.com> wrote ---- 
...
 > > But after chrooting to update-initramfs and cataloging resulting image content, usb_storage and uas were present under /lib/modules/xxx already, and failing systems still just busybox without a real rootfs rather than launch systemd; even tried kernel option "rootwait" which had no effect on access to ext storage; udev still seems not to have noticed the ext drives once busybox had control. 
 >  
 > Still looks like a initramfs problem other than btrfs problem. 
 >  
 > In the busybox environment, have you tried listing /dev to see if that 
 > external device is found? 

agreed that initramfs smells bad, but it hadn't been a problem until btrfs mounts (external-raid) had to rely on the usb channel;
in busybox, ext drives/partitions are all missing from /dev; can't tell why so, ahci and usb modules are loaded afaict

 > Since you have a busybox environment, have you checked if "btrfs" command lives in the initramfs? 

yes btrfs command works from busybox

 > IIRC at least you need the following things/abilities to boot: 
 >  
 > 1) usb and sata drivers 
 >    Means you could see both devices in the busybox environment under /dev 
 >  
 > 2) "Btrfs" command 
 >    Mostly for scan 
 > Then you could try the following commands under busybox environment: 
 > # btrfs device scan 
 > # mount <device> <some temporary mount point> 

"btrfs dev scan" runs but doesn't indicate recognizing any; since raid1 conversion, ext drives are required for any btrfs mounts to be seen whole.
When manually trying to mount in busybox, it gives a similar error about missing external device by UUID_SUB

 > If it works, it may mean you're missing "btrfs device scan" during boot 
 > so kernel can't see all RAID1 disks for btrfs and failed to boot. 
 >  
 > Please refer to your distribution initramfs creation tool to see how to 
 > add that scan. (Some distro has special hook for btrfs to handle such case). 

may have to tweak the /etc/initramfs-tools/initramfs.conf or modules list; MODULES=dep setting might act better than MODULES=most
will look into this further to see about contrasting block device modules between cindy and the others

appreciate the timely response-
TP

