Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:37599 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeHEQPT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2018 12:15:19 -0400
Received: by mail-oi0-f45.google.com with SMTP id j205-v6so17793587oib.4
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Aug 2018 07:10:36 -0700 (PDT)
MIME-Version: 1.0
From: James Courtier-Dutton <james.dutton@gmail.com>
Date: Sun, 5 Aug 2018 15:09:55 +0100
Message-ID: <CAAMvbhED_WrVH5VHL9ND4dpMdS+C5erVnXJQcpwbKU2YnoMu6A@mail.gmail.com>
Subject: BUG: scheduling while atomic
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am seeing a server halt and require a manual restart that I think
might be related to btrfs.
I attach the kernel log from it, in the hope that someone will
understand it better than me.
Any clues?

https://paste.fedoraproject.org/paste/xSblK1RKANiwhKHQj31Cdw


Kind Regards

James
