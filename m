Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47048 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IAGPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:15 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so3499866pdj.17
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:14 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:09 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Subject: Re:  btrfs-progs: replace fails start but in the background
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5222db6d.BZHsv21X05DJlFsh%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
WARNING: please, no space before tabs
#83: FILE: utils.c:1999:
+ * ^Ifrom the user cli like device add remove replace balance etc..$

total: 0 errors, 1 warnings, 50 lines checked

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
