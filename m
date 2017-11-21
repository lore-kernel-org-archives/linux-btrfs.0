Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:44361 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdKUMIz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 07:08:55 -0500
Received: by mail-wm0-f53.google.com with SMTP id r68so2906082wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 04:08:54 -0800 (PST)
Received: from debox (bzq-109-65-163-184.red.bezeqint.net. [109.65.163.184])
        by smtp.gmail.com with ESMTPSA id x185sm1142769wmx.12.2017.11.21.04.08.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Nov 2017 04:08:52 -0800 (PST)
Message-ID: <1511266131.1680.27.camel@gmail.com>
Subject: quotas: failure on removing a file via SFTP/SSH
From: ST <smntov@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Tue, 21 Nov 2017 14:08:51 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to use quotas for a simple chrooted sftp setup, limiting
space for each user's subvolume (now for testing to 1M).

I tried to hit the limit by uploading files and once it comes to the
limit I face following problem: if I try to free space by removing a
file via Linux sftp client (or Filezilla) - I get error:
"Couldn't delete file: Failure"

Sometimes, but not always, if I repeat it for 3-5 times it does removes
the file at the end.
If I login as root and try to remove the file via SSH I get the error:
"rm: cannot remove 'example.txt': Disk quota exceeded"

What is the problem? And how can I solve it?

Thank you in advance!


