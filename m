Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33779 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754985AbcJLN6q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 09:58:46 -0400
Received: by mail-ua0-f172.google.com with SMTP id p25so6371112uaa.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 06:58:41 -0700 (PDT)
MIME-Version: 1.0
From: Abhay Sachan <lkp.abhay@gmail.com>
Date: Wed, 12 Oct 2016 19:28:20 +0530
Message-ID: <CAKHchJzbo7=fZrtbOwaMdMNiYMSdUuiys3iHTpyxTP92SAY1TQ@mail.gmail.com>
Subject: Btrfs progs build fails for 4.8
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I tried building latest btrfs progs on CentOS 6, "./configure" failed
with the error:

checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h... no
configure: error: no definition of FIEMAP_EXTENT_SHARED found

Any ideas what am I lacking in the system?

Regards,
Abhay
