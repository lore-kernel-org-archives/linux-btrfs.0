Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFEEC65C22
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B2E2082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="jZNu/xsr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10B2E2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbeKCGjA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:39:00 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40607 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeKCGi7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:38:59 -0400
Received: by mail-it1-f196.google.com with SMTP id e11so1798318itl.5
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m5BROwurQKxczGsj4fbck9Sm2kxpwdnTNwXP0TSnM/Q=;
        b=jZNu/xsrLTHV/usJ/NccmGwYetRzYCkBGMzJPRaS+RXm2kGZGjQw6KYwe654zLOBe0
         2XunczJmF1qQb4fbntXHwBQgJUHTGrlEVmfdPwwNxz5dAwbSLuj1CDmAVP7P/0EH4fAb
         Pf1QIISgtYKhXYJcevc/EExcKWcGkHtfJeQh9+td1EacpEo2Wr55hsevElhx+dF8SpbX
         Q9jLY2mZS+AImdVfYhGPIkFHv7F89NHusGmApP0NF9j2Xiq4WfE0XR865U5SECAtnxvj
         5QJBlSX2PTDesKvoVPgyUH9UlNjtLEHJ2fRlfJB+v//dq8YQsXlJR8ST/M92tFSEHRKE
         pejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m5BROwurQKxczGsj4fbck9Sm2kxpwdnTNwXP0TSnM/Q=;
        b=a0rrPjpI8ziR49dyjymEWMU3t5gDSA+Gg7MLBlqzUJiGov+7gvrYP3m8qp2G16W0PX
         vIaPvofVx5UuhnxZxcbI1Uiu2Wh32b1wfyI/+zTpx4bNX0YLWwyyM4XY6BOzFVH2q2WH
         qU9n5kScvVOzw2UGbmluVHxjukWGEEUVB9vaxh8FkWV9wHqA5+7YfYYAgm91h0BrvU4F
         xki7ADFllGcqxxaR4f3wP8DoUrs+9nStnfsvTN0vdqHm05czZdIf28dj/Ca6NnwiWHoj
         Hy8GD3Li1CPvPgjqq7ZJowvLmB3rK1rwfenlRkHiRGl6lEzSZtet5Cm6YVJfZYQCTBmD
         A/Jw==
X-Gm-Message-State: AGRZ1gK8uy3QEH3THHqKF2S95+DAQ7NeYpiZ1e+IwAbbV/8VhkE+Cf5R
        W8mJ+8geI2R7h7b9PgxsM4sdJA==
X-Google-Smtp-Source: AJdET5eGNytvkYSuq8Z50y/lglN8O3bKKH1iGw4FRdjX433N2jtiQM7cYy4oS2JE1iQbkbt/1VgsFQ==
X-Received: by 2002:a02:2b29:: with SMTP id h41-v6mr11470226jaa.12.1541194211724;
        Fri, 02 Nov 2018 14:30:11 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:11 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] generic/{472,496}: fix swap file creation on Btrfs
Date:   Fri,  2 Nov 2018 14:29:37 -0700
Message-Id: <6da5f398715af4f7478554920470a85e8a186b50.1541193856.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541193856.git.osandov@fb.com>
References: <cover.1541193856.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The swap file must be set nocow before it is written to, otherwise it is
ignored and Btrfs refuses to activate it as swap.

Fixes: 25ce9740065e ("generic: test swapfile creation, activation, and deactivation")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/generic/472 | 14 ++++++--------
 tests/generic/496 |  6 +++---
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tests/generic/472 b/tests/generic/472
index 04ed3e73..aba4a007 100755
--- a/tests/generic/472
+++ b/tests/generic/472
@@ -42,13 +42,15 @@ _scratch_mount >>$seqres.full 2>&1
 
 swapfile=$SCRATCH_MNT/swap
 len=$((2 * 1048576))
-page_size=$(get_page_size)
 
 swapfile_cycle() {
 	local swapfile="$1"
+	local len="$2"
 
+	touch $swapfile
 	# Swap files must be nocow on Btrfs.
 	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
+	_pwrite_byte 0x58 0 $len $swapfile >> $seqres.full
 	"$here/src/mkswap" $swapfile >> $seqres.full
 	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
 	swapoff $swapfile 2>> $seqres.full
@@ -57,20 +59,16 @@ swapfile_cycle() {
 
 # Create a regular swap file
 echo "regular swap" | tee -a $seqres.full
-_pwrite_byte 0x58 0 $len $swapfile >> $seqres.full
-swapfile_cycle $swapfile
+swapfile_cycle $swapfile $len
 
 # Create a swap file with a little too much junk on the end
 echo "too long swap" | tee -a $seqres.full
-_pwrite_byte 0x58 0 $((len + 3)) $swapfile >> $seqres.full
-swapfile_cycle $swapfile
+swapfile_cycle $swapfile $((len + 3))
 
 # Create a ridiculously small swap file.  Each swap file must have at least
 # two pages after the header page.
 echo "tiny swap" | tee -a $seqres.full
-tiny_len=$((page_size * 3))
-_pwrite_byte 0x58 0 $tiny_len $swapfile >> $seqres.full
-swapfile_cycle $swapfile
+swapfile_cycle $swapfile $(($(get_page_size) * 3))
 
 status=0
 exit
diff --git a/tests/generic/496 b/tests/generic/496
index 968b8012..3083eef0 100755
--- a/tests/generic/496
+++ b/tests/generic/496
@@ -49,8 +49,6 @@ page_size=$(get_page_size)
 swapfile_cycle() {
 	local swapfile="$1"
 
-	# Swap files must be nocow on Btrfs.
-	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
 	"$here/src/mkswap" $swapfile >> $seqres.full
 	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
 	swapoff $swapfile 2>> $seqres.full
@@ -59,8 +57,10 @@ swapfile_cycle() {
 
 # Create a fallocated swap file
 echo "fallocate swap" | tee -a $seqres.full
-$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
+touch $swapfile
+# Swap files must be nocow on Btrfs.
 $CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
 "$here/src/mkswap" $swapfile
 "$here/src/swapon" $swapfile >> $seqres.full 2>&1 || \
 	_notrun "fallocated swap not supported here"
-- 
2.19.1

