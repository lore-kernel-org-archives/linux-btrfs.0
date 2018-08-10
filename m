Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua1-f41.google.com ([209.85.222.41]:42925 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbeHJMg5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 08:36:57 -0400
Received: by mail-ua1-f41.google.com with SMTP id w7-v6so1265247uan.9
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 03:07:45 -0700 (PDT)
MIME-Version: 1.0
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Fri, 10 Aug 2018 13:07:44 +0300
Message-ID: <CAN4oSBd9aVn9Ruv83fd=oE4hJhGw7y3f1EbJ+SNbHMZZyZo=Mw@mail.gmail.com>
Subject: How to ensure that a snapshot is not corrupted?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Original question is here: https://superuser.com/questions/1347843

How can we sure that a readonly snapshot is not corrupted due to a disk failure?

Is the only way calculating the checksums one on another and store it
for further examination, or does BTRFS handle that on its own?
