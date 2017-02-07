Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35260 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753909AbdBGNxg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 08:53:36 -0500
Received: by mail-vk0-f47.google.com with SMTP id x75so77878846vke.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 05:53:36 -0800 (PST)
MIME-Version: 1.0
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 08:53:35 -0500
Message-ID: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
Subject: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have tried BTRFS from Ubuntu 16.04 LTS   for write intensive OLTP MySQL
Workload.

It did not go very well ranging from multi-seconds stalls where no
transactions are completed to the finally kernel OOPS with "no space left
on device" error message and filesystem going read only.

I'm complete newbie in BTRFS so  I assume  I'm doing something wrong.

Do you have any advice on how BTRFS should be tuned for OLTP workload
(large files having a lot of random writes)  ?    Or is this the case where
one should simply stay away from BTRFS and use something else ?

One item recommended in some places is "nodatacow"  this however defeats
the main purpose I'm looking at BTRFS -  I am interested in "free"
snapshots which look very attractive to use for database recovery scenarios
allow instant rollback to the previous state.

-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
