Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58262 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3E0QVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 12:21:44 -0400
Received: by mail-wg0-f47.google.com with SMTP id e11so4477154wgh.26
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 09:21:43 -0700 (PDT)
Received: from noname.localnet (dsl51B6D2E0.pool.t-online.hu. [81.182.210.224])
        by mx.google.com with ESMTPSA id fu14sm18443039wic.8.2013.05.27.09.21.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 27 May 2013 09:21:42 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: systemd "journalctl" is 1.89sec on ext4, 1.49 min on btrfs
Date: Mon, 27 May 2013 18:21:21 +0200
Message-ID: <16735484.PAleCPYpY8@noname>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

I have two openSUSE 12.3 systems with kernel 3.9. On one of them there's an 
ext4 partition, while on the other there's a btrfs.

I issued a "time journalctl -b --no-pager" command on both systems. This shows 
the logs from the current boot without passing them to "less".

On ext4 (3.9.3):
real    0m1.898s
user    0m0.291s
sys     0m0.105s

On btrfs (3.9.2):
real    1m49.698s
user    0m0.102s
sys     0m0.470s

Journalctl on btrfs was always this slow, some btrfsck were made on the file 
system too, but I don't think it was corrupted. On just the first run it's 
sluggish, after it's fast as the ext4 one.

Is it a known issue or can I help somehow debugging this further?

Best regards,

Ákos Szőts
