Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:35112 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757959AbcKCOzW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 10:55:22 -0400
Received: by mail-vk0-f49.google.com with SMTP id w194so41732956vkw.2
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Nov 2016 07:55:22 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Thu, 3 Nov 2016 10:55:21 -0400
Message-ID: <CAJtFHUS4pr-_XdkdGffdx8kUdjp8ju_qN3xHQxHKysyCg-YNeQ@mail.gmail.com>
Subject: linux 4.9-rc3 OOM's anyone else?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like 4.9-rc3 still has the OOM issue since 4.7 as far as I can
tell. Anyone else still seeing it?

I created a kernel bug report for it:
https://bugzilla.kernel.org/show_bug.cgi?id=186671. Not sure if it's
btrfs that's making it worse or what not.
