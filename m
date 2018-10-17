Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D26ECDE39
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 16:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D43942145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 16:54:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=zoho.com header.i=tprokott@zoho.com header.b="mPQniHYU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D43942145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=zoho.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbeJRAuj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 20:50:39 -0400
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25448 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbeJRAuj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 20:50:39 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2018 20:50:37 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1539794341; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=fDxhTKJmG25AatqAP2yCdymWHl/QZnfWe5k193idzlMsnW7BUqVBuRxdhL9488WrTIhlpxS27/BJbzcGNmZjEHzCfFdKxxO5mQY7KrfYb+6CuI1W3k48RX27krJcVYuRvYDm9eaPtPE/mgg7b+nOIHUEXrQuXQMR+FMfempnnqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1539794341; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=R/71OT0twuaqgi2pUXM2wXT7G6Bwx6E024prqdCFSUg=; 
        b=TTjfcOZLoWIZGSYv5Id/afls1yGgUQUvgl90fXoYr0FKNdn8SxxhVu6M5yhw0Gi3t/R44nhuR4fgXwXbG/SzJONXETSBUPDzckG8qtHHUpZLTaTgSfzYJpyseAK7nXfEB4eWl8eH8hNHJ9Nt/v9fureu/gkIFijV45w5AXy3ZEg=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=tprokott@zoho.com;
        dmarc=pass header.from=<tprokott@zoho.com> header.from=<tprokott@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=date:from:to:message-id:in-reply-to:subject:mime-version:content-type:user-agent; 
  b=L6kCLnWm4IM/N8sI1/7JrHMigy4sBQUSnnHgXEx/337z5otqL7NU6jaKMm6odQdw5JfS8L23uT0R
    b8oABr5HStx1/ztEjS3JoQYtYQZnpDQHzcYL7gBw1zLIfa1WvmWD  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1539794341;
        s=default; d=zoho.com; i=tprokott@zoho.com;
        h=Date:From:To:Message-ID:In-Reply-To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=3745; bh=R/71OT0twuaqgi2pUXM2wXT7G6Bwx6E024prqdCFSUg=;
        b=mPQniHYUQhDVHuEnCrLn5IUhJGxuo2L9uS7TSNHltSLN8hDSt8hB5Nr6qUrQUnWg
        UL+sNr9yYfAUoW/Psp8b/RvzT4PYMjmrodxX4sJwPKYusny45NhbYFRXYumz0Z9cuo2
        JuytVwevDz7LQ7PJzbzxSxv8eftBUrCpV/AV4uqc=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1539794339099511.30505104945587; Wed, 17 Oct 2018 09:38:59 -0700 (PDT)
Received: from  [24.7.203.165] by mail.zoho.com
        with HTTP;Wed, 17 Oct 2018 09:38:59 -0700 (PDT)
Date:   Wed, 17 Oct 2018 09:38:59 -0700
From:   Tony Prokott <tprokott@zoho.com>
To:     "linux-btrfs" <linux-btrfs@vger.kernel.org>
Message-ID: <16682e5051a.ee83c20873105.8360554719511192350@zoho.com>
In-Reply-To: 
Subject: Conversion to btrfs raid1 profile on added ext device renders some
 systems unable to boot into converted rootfs
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

Good day. My technical trouble seems to be beyond the scope of active helpers on debian's irc support channel. Reasonable supposition that it's quite particular to the development stage of btrfs infrastructure on 4.17.xxx backport kernels and userland tools available on debian 9.5 stretch as well as buster, the testing suite to be released in the next several months as 10.0 stable. 

 > / # uname -a; lsb_release -a
 > Linux localhost 4.17.0-0.bpo.3-amd64 #1 SMP Debian 4.17.17-1~bpo9+1 (2018-08-27) x86_64 GNU/Linux
 > Distributor ID: LinuxMint
 > Description: LMDE 3 Cindy
 > Release: 3
 > Codename: cindy
 > 
 > / # btrfs --version
 > btrfs-progs v4.7.3
 > 
 > / # btrfs fi sh
 > Label: 'sys'  uuid: [snip]
 > Total devices 2 FS bytes used 24.07GiB
 > devid    1 size 401.59GiB used 26.03GiB path /dev/sda2
 > devid    2 size 401.76GiB used 26.03GiB path /dev/sdc1
 > 
 > / # btrfs fi df /
 > Data, RAID1: total=24.00GiB, used=23.27GiB
 > System, RAID1: total=32.00MiB, used=16.00KiB
 > Metadata, RAID1: total=2.00GiB, used=820.00MiB
 > GlobalReserve, single: total=69.17MiB, used=0.00B
 > 
 > / # btrfs su li -ta /
 > ID	gen	top level	path
 > --	---	---------	----
 > 260	115103	5		<FS_TREE>/d9
 > 261	115103	5		<FS_TREE>/d10
 > 262	123876	5		<FS_TREE>/home
 > 263	115148	261		<FS_TREE>/d10/@
 > 264	115136	261		<FS_TREE>/d10/@home
 > 443	123874	447		<FS_TREE>/md3/@
 > 444	123876	447		<FS_TREE>/md3/@home
 > 447	115103	5		<FS_TREE>/md3
 > 451	115144	260		<FS_TREE>/d9/@
 > 452	115136	260		<FS_TREE>/d9/@home

Providing no dmesg content so far, as it doesn't bear on the kind of difficulty in question. My system requires expert help now to restore bootability to 2 of its OS installations; it has a btrfs root file system in subvolumes for stretch, buster, and LMDE3(cindy) which derives directly from stretch and so has most core elements if not cfg defaults in common; even kernel versions are alike, besides buster. subvolid=262 is a  /home fs shared among  linux distros; 451, 263, and 443 are rootfs for stretch, buster and cindy respectively.

All 3 installations had been booting and running fine when data block group profile was "single" on an internal sata HDD /dev/sda2; then an external usb3 drive enclosure's sata HDD partition /dev/sdc1, also of size ~0.4TiB, was added and balanced as btrfs "raid1"; raid conversion did not damage subvolume content or filesystem integrity afaict, but rather rendered stretch and buster unbootable (more to follow), whereas cindy carried on without hiccup.

At first it seemed as though the initrd's might be missing a module or so, to allow access to external drives -- i.e. grub starts the unbootable kernel/initrd but drops to busybox prompt right away without starting external drives, referring to allegedly "missing" btrfs device's UUID_SUB.

But after chrooting to update-initramfs and cataloging resulting image content, usb_storage and uas were present under /lib/modules/xxx already, and failing systems still just busybox without a real rootfs rather than launch systemd; even tried kernel option "rootwait" which had no effect on access to ext storage; udev still seems not to have noticed the ext drives once busybox had control.

I could list all initrd modules present in cindy & absent for others, but need better knowledge than my reasonable guesses of what's required to make btrfs volume companion devices cooperate at boot time, as initrd transitions to steady state rootfs.

What would be a more practical diagnostic? Could stretch & buster initrd's somehow be failing to do a btrfs device scan at the proper moment? Not so interested in giving up on btrfs software raid so early in the game.

thanks in advance-
TP [not a list subscriber]


