Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805D5C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 05:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE1620700
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 05:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cShPYAO3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EE1620700
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbeLGFYy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 00:24:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37174 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLGFYx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 00:24:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so3214152wmd.2
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 21:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=HWI/JLlOQ7TQwDuGkZuUwR02Lj7SUeRywbrkhyA2118=;
        b=cShPYAO3j7R+KpkMFpAk0x0QRLpRhKZgn2NJWN9I3dOvKSO5dB7WcXbiN9NvLfX1Hq
         JcS2Sj2h/tRg2Jgrf0P3S2tCLSOfsBxptUDjbU2U/fDGQiSDvVBo8i2GJgl1bMHMsyPP
         PaBuHRV7Z2g0PGd1iJTSo/bYKlZKStlGu3i6/RuAadE8Ey6HGOA1vowzzbt4284GPJOn
         uHh/xnQ8JCSxznq7KZ7rQMxNpvaNPC+x1NvnibXmPVdprkhsqB8lmSukXn2lu7EdpBqy
         d0clxjTRXvvFu8QIqmN7T5nnbovD9tH896UEaCep79QjnvNPbABhP9B7XhbREcq4uv2q
         YfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HWI/JLlOQ7TQwDuGkZuUwR02Lj7SUeRywbrkhyA2118=;
        b=aBvGNG9FVGWtk6PsEEpa5aDxXL7ft1QopxkaZlfVXWqcX7PDN2LAoeBUToSQErRaLc
         iJ/5Jur28py9m46FjBeE4gvRzFauwYCo1+7WE1OjPX5MU9HJXiKjNOkPwWVKetlB7LRF
         Co6SAE6O6onrzDZb6cDCokkaD0aI3HNgSrOC3z7cCpsYY33POVIK9aHcxfRAwIAlTlXW
         Q7mXqJC15YTBwcx/qWjUKFhFodytEvCKGOpN4aEgJuLMxH+6TDpVyWnjdFVEWNjW8DCp
         hq0J/PLEPtPrzUSWJsLmEsqSIRKYI0/VJHJgeb3ExgKAJYJHFspaMhN0cJ4jzSzkvuz4
         w8sA==
X-Gm-Message-State: AA+aEWboucyUFAD1GW1EziJ/WOZkmzmszHWbTc3DAKAc0oHZLrqcb3C3
        9Sx2ooyn2LtN+2ZGveqP9AI/8239GIrrSl8YVN76Q1Wf
X-Google-Smtp-Source: AFSGD/VGJX4O2d9BCSRjb3sYlvafF9pdNKgf9ZE5wmFc0tRFQVLVOuowi/Z9CS2kUrua2HJqW+9hNi1Y65Rnv6fLeu4=
X-Received: by 2002:a1c:9183:: with SMTP id t125mr854088wmd.79.1544160290825;
 Thu, 06 Dec 2018 21:24:50 -0800 (PST)
MIME-Version: 1.0
From:   Doni Crosby <doni.crosby1995@gmail.com>
Date:   Fri, 7 Dec 2018 00:24:40 -0500
Message-ID: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
Subject: System unable to mount partition after a power loss
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All,

I'm coming to you to see if there is a way to fix or at least recover
most of the data I have from a btrfs filesystem. The system went down
after both a breaker and the battery backup failed. I cannot currently
mount the system, with the following error from dmesg:

Note: The vda1 is just the entire disk being passed from the VM host
to the VM it's not an actual true virtual block device

[ 499.704398] BTRFS info (device vda1): disk space caching is enabled
[  499.704401] BTRFS info (device vda1): has skinny extents
[  499.739522] BTRFS error (device vda1): parent transid verify failed
on 3563231428608 wanted 5184691 found 5183327
[  499.740257] BTRFS error (device vda1): parent transid verify failed
on 3563231428608 wanted 5184691 found 5183327
[  499.770847] BTRFS error (device vda1): open_ctree failed

I have tried running btrfsck:
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563224121344 wanted 5184691 found 5184688
parent transid verify failed on 3563221630976 wanted 5184691 found 5184688
parent transid verify failed on 3563221630976 wanted 5184691 found 5184688
parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
parent transid verify failed on 3563223138304 wanted 5184691 found 5184688
parent transid verify failed on 3563224072192 wanted 5184691 found 5184688
parent transid verify failed on 3563224072192 wanted 5184691 found 5184688
parent transid verify failed on 3563225268224 wanted 5184691 found 5184689
parent transid verify failed on 3563225268224 wanted 5184691 found 5184689
parent transid verify failed on 3563227398144 wanted 5184691 found 5184689
parent transid verify failed on 3563227398144 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
parent transid verify failed on 3563229593600 wanted 5184691 found 5184689
Ignoring transid failure
Checking filesystem on /dev/vda1
UUID: 7c76bb05-b3dc-4804-bf56-88d010a214c6
checking extents
parent transid verify failed on 3563224842240 wanted 5184691 found 5184689
parent transid verify failed on 3563224842240 wanted 5184691 found 5184689
parent transid verify failed on 3563222974464 wanted 5184691 found 5184688
parent transid verify failed on 3563222974464 wanted 5184691 found 5184688
parent transid verify failed on 3563223121920 wanted 5184691 found 5184688
parent transid verify failed on 3563223121920 wanted 5184691 found 5184688
parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
parent transid verify failed on 3563229970432 wanted 5184691 found 5184689
Ignoring transid failure
parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
parent transid verify failed on 3563231428608 wanted 5184691 found 5183327
Ignoring transid failure
parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
parent transid verify failed on 3563231444992 wanted 5184691 found 5183325
Ignoring transid failure
parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
parent transid verify failed on 3563231412224 wanted 5184691 found 5183325
Ignoring transid failure
parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
parent transid verify failed on 3563231461376 wanted 5184691 found 5183325
Ignoring transid failure
Segmentation fault

btrfs check --recover also ends in a segmentation fault

I am aware of chunk-recover and have tried to run it but got weary
when I saw dev0 not vda1.

Any help would be appreciated,
Doni

uname -a:
Linux Homophone 4.18.0-0.bpo.1-amd64 #1 SMP Debian 4.18.6-1~bpo9+1
(2018-09-13) x86_64 GNU/Linux

btrfs --version:
btrfs-progs v4.7.3

btrfs fi show:
Label: 'Array'  uuid: 7c76bb05-b3dc-4804-bf56-88d010a214c6
        Total devices 1 FS bytes used 6.05TiB
        devid    1 size 29.11TiB used 6.13TiB path /dev/vda1
