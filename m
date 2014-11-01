Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50778 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbaKAUu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 16:50:26 -0400
Received: by mail-wg0-f43.google.com with SMTP id y10so5663508wgg.30
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 13:50:24 -0700 (PDT)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id wc7sm16441092wjc.8.2014.11.01.13.50.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Nov 2014 13:50:24 -0700 (PDT)
Message-ID: <5455478F.10305@gmail.com>
Date: Sat, 01 Nov 2014 21:50:23 +0100
From: KC <qwrules@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs check shows errors - What now?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

  I have a disk corruption problem. I run btrfs check on my system and 
data partitions, and I got worrying results:
  http://pastebin.com/hpi57xy6

What should I do now? Can I run btrfs check -repair on it, or does it 
bear risk of shredding my data?
What other options do I have except of copying everything and 
reformatting the partition?


