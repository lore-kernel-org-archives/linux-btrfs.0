Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33422 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdISPac (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:30:32 -0400
Received: by mail-wm0-f66.google.com with SMTP id m127so4246592wmm.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 08:30:32 -0700 (PDT)
Received: from [10.3.28.18] ([155.210.222.97])
        by smtp.gmail.com with ESMTPSA id u186sm1679963wmd.19.2017.09.19.08.30.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Sep 2017 08:30:30 -0700 (PDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Pat Sailor <psalleetsile@gmail.com>
Subject: SSD caching an existing btrfs raid1
Message-ID: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
Date: Tue, 19 Sep 2017 17:30:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a half-filled raid1 on top of six spinning devices. Now I have 
come into a spare SSD I'd like to use for caching, if possible without 
having to rebuild or, failing that, without having to renounce to btrfs 
and flexible reshaping.

I've been reading about the several options out there; I thought that 
EnhanceIO would be the simplest bet but unfortunately I couldn't get it 
to build with my recent kernel (last commits are from years ago).

Failing that, I read that lvmcache could be the way to go. However, I 
can't think of a way of setting it up in which I retain the ability to 
add/remove/replace drives as I can do now with pure btrfs; if I opted to 
drop btrfs to go to ext4 I still would have to offline the filesystem 
for downsizes. Not a frequent occurrence I hope, but now I'm used to 
keep working while I reshape things in btrfs, and it's better if I can 
avoid large downtimes.

Is what I want doable at all? Thanks in advance for any 
suggestions/experiences to proceed.

