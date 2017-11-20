Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:33243 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdKTQub (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 11:50:31 -0500
Received: by mail-wr0-f174.google.com with SMTP id 4so8677462wrt.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:50:31 -0800 (PST)
Received: from debox (bzq-79-176-67-119.red.bezeqint.net. [79.176.67.119])
        by smtp.gmail.com with ESMTPSA id m189sm5469297wmb.38.2017.11.20.08.50.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Nov 2017 08:50:29 -0800 (PST)
Message-ID: <1511196626.1657.29.camel@gmail.com>
Subject: test btrfs scrubbing/get system's total capacity
From: ST <smntov@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Mon, 20 Nov 2017 18:50:26 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

1. is there a tool that I can use to test btrfs scrubbing? Namely I need
to "damage" a file, i.e. change it without changing its meta
information, so I can see how scrubbing performs... Is there something
like this?


2. I want to use Ansible to set btrfs quota on a /home subvolume as say
0.8*TotalCapacityOfRoot and then assign to it individual users'
subvolumes with certain (smaller) quatos.
2.1 Is it OK to rely on ansible_facts? Does it has correct information
about btrfs-based "/" total capacity?
2.2 If not, is there a raw command to get TotalCapacityOfRoot in -TB so
I can set it? Is there something like btrfs filesystem usage / -t
--device_size? to get only the total Device Size information?

Thank you!
ST

