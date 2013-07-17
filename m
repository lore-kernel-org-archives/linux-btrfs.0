Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41178 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3GQVY0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 17:24:26 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so913734bkb.5
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 14:24:25 -0700 (PDT)
Received: from horus.localnet ([2001:4ca0:302:0:224:1dff:fed7:99b])
        by mx.google.com with ESMTPSA id hn4sm2497247bkc.2.2013.07.17.14.24.23
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 17 Jul 2013 14:24:24 -0700 (PDT)
From: Florian Lindner <mailinglists@xgm.de>
To: linux-btrfs@vger.kernel.org
Subject: Questions about multi-device behavior
Date: Wed, 17 Jul 2013 23:24:22 +0200
Message-ID: <1860433.azE0Vf7tMy@horus>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I create a btrfs volume comprised of two partitions:

# mkfs.btrfs -m dup -d single /dev/sdd1 /dev/sde1

metadata ist mirrored on each device, data chunks are scattered more or less 
randomly on one disk. 

a) If one disk fails, is there any chance of data recovery? 
b) If not, is there any advantage over a raid0 configuration.

Thanks and regards,

Florian
