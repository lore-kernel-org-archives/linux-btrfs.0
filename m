Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:34670 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdFVJhQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 05:37:16 -0400
Received: by mail-ot0-f171.google.com with SMTP id r67so7150375ota.1
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jun 2017 02:37:15 -0700 (PDT)
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 22 Jun 2017 15:07:14 +0530
Message-ID: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
Subject: Stability status of btrfs-convert...
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm planning to use the btrfs-convert tool to convert production data
in ext4 filesystem into btrfs.
What is the stability status of this feature?

As per the below link, this tool is not in frequent use in latest linux kernels.
https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

Can I know the reason why? Is it because most existing ext4
filesystems are already converted?
Is this tool supported, at least? Can I use this tool as a part of
software upgrade to change the data filesystem to btrfs?

Thanks in advance for your help.
-- 
-Shyam
