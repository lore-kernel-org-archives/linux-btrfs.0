Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33869 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752706AbcIOTPx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 15:15:53 -0400
Received: by mail-yw0-f178.google.com with SMTP id g192so70878932ywh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 12:15:53 -0700 (PDT)
From: Vincent Batts <vbatts@hashbangbash.com>
To: linux-btrfs@vger.kernel.org
Cc: Vincent Batts <vbatts@hashbangbash.com>
Subject: [PATCH] Expose verbose flag on subvolume delete
Date: Thu, 15 Sep 2016 15:15:49 -0400
Message-Id: <20160915191550.12371-1-vbatts@hashbangbash.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Exposing the verbose flag that already had the logic for verbose output

Vincent Batts (1):
  btrfs-progs: subvolume verbose delete flag

 cmds-subvolume.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.9.0

