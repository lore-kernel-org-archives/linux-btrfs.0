Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:35262 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdEEP5T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 11:57:19 -0400
Received: by mail-yb0-f170.google.com with SMTP id p143so2326692yba.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 08:57:19 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/3] Kill btree inode prep patches
Date: Fri,  5 May 2017 11:57:12 -0400
Message-Id: <1493999835-26731-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These three patches are just prep patches for the kill btree inode patch, they
just move some stuff around so we don't depend on struct inode in places where
we won't have one.  Once the other supporting generic code goes in I'll submit
the kill btree inode patch as well.  Thanks,

Josef
