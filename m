Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF89C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF92D21473
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 04:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF92D21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sysnux.pf
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbeJRMBR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 08:01:17 -0400
Received: from [195.159.176.226] ([195.159.176.226]:47037 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbeJRMBR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 08:01:17 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gCzTi-0005Hl-6c
        for linux-btrfs@vger.kernel.org; Thu, 18 Oct 2018 06:00:06 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Untar on empty partition returns ENOSPACE
Date:   Wed, 17 Oct 2018 18:02:08 -1000
Message-ID: <pq90ft$hso$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
X-Mozilla-News-Host: news://news.gmane.org:119
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi list,

My goal is to duplicate some SD cards, to prepare 50 similar Raspberry Pi.

First, I made a tar of my master SD card (unmounted). Then I made a
script, which creates 2 partitions (50 MB for boot, 14 GB for /),
creates the file-systems (vfat and btrfs, default options), mounts the
two partitions:

mount $part2 $mnt
-ocompress=zstd,space_cache=v2,autodefrag,noatime,nodiratime
mkdir $mnt/boot
mount $part1 $mnt/boot

When untarring, I get many errors, like:
tar:
./usr/lib/libreoffice/share/gallery/arrows/A45-TrendArrow-Red-GoUp.png :
open impossible: No space left on device
tar:
./usr/lib/libreoffice/share/gallery/arrows/A53-TrendArrow-LightBlue-TwoDirections.svg
: open impossible: No space left on device
tar:
./usr/lib/libreoffice/share/gallery/arrows/A27-CurvedArrow-DarkRed.png :
open impossible: No space left on device
tar:
./usr/lib/libreoffice/share/gallery/arrows/A41-CurvedArrow-Gray-Left.svg
: open impossible: No space left on device

Which usually results in unusable SD card.

When the first errors occur, less than 1 GB has been written. I tried to
change mount options, especially commit interval, but still got ENOSPACE.

What I ended up doing is limiting write speed with:
xzcat $archive | pv -L 4M | tar x
(with -L 5M I start to get a couple of errors)

Is there a better work around? Or a patch to test that could help?

The machine that runs the script has:
[jdg@tiare tar-install]$ uname -r
4.19.0-rc7-snx
[jdg@tiare tar-install]$ btrfs version
btrfs-progs v4.17.1


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

