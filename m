Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:36643 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdFRTMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 15:12:07 -0400
Received: by mail-wr0-f182.google.com with SMTP id c11so5744643wrc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Jun 2017 12:12:07 -0700 (PDT)
Received: from [192.168.1.101] ([95.70.161.96])
        by smtp.gmail.com with ESMTPSA id g203sm10050190wmd.23.2017.06.18.12.12.05
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Jun 2017 12:12:05 -0700 (PDT)
In-Reply-To: 
To: linux-btrfs@vger.kernel.org
From: Cengiz Can <cengizc@gmail.com>
Subject: btrfs fi usage crash when multiple device volume contains seed device
Message-ID: <0a80fc76-0573-e92b-0517-46d446515c5f@gmail.com>
Date: Sun, 18 Jun 2017 22:12:06 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

How should we proceed on this?

I want to deep dive and contribute to btrfs and its toolings with this 
issue but I don't have enough experience with them.

As far as I understand, fixing this would require some design decisions 
which I hope to hear in this thread soon.

Thanks
Cengiz Can


