Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36203 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbdKQD42 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 22:56:28 -0500
Received: by mail-pf0-f179.google.com with SMTP id i15so981424pfa.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 19:56:27 -0800 (PST)
Received: from [192.168.0.181] (d50-99-92-72.abhsia.telus.net. [50.99.92.72])
        by smtp.gmail.com with ESMTPSA id n2sm3978885pgv.69.2017.11.16.19.56.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Nov 2017 19:56:26 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Jay <j4y0t15@gmail.com>
Subject: Btrfs restore error
Message-ID: <2382a8cf-2137-9622-6074-a082bcbe2b94@gmail.com>
Date: Thu, 16 Nov 2017 20:56:25 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I thought I should report something since there was little information
on this error. The situation is I have 2 external hard drives on
Xubuntu. One is not working and I need to move the data over to the
other. I used 'sudo btrfs restore -v /dev/sde1 /mnt/Old4TB' and
received 'Error mkdiring /mnt/Old4TB/Jayda TV:2'. I found one forum
post that said I needed to make the destination folder manually, then
restore. That did not work. looking at your code 2(%d) is a kernel
message? not sure what to make of it. I decided to enter a root
environment with 'sudo su' and the restore worked(the folder still
existed from previous troubleshoot step). The console is showing files
being restored. I tried a dry run first which did not show an error.
Just some feedback and reference.

uname -a

Linux emb 4.10.0-38-generic #42-16.04.1-Ubuntu SMP Tue Oct 10 16:21:20
UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version

btrfs-progs v4.4

Thank you,

Jayotis
