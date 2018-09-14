Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.idedalo.net ([178.33.75.195]:47086 "EHLO mx1.idedalo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbeINWwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 18:52:25 -0400
Received: from localhost (ip6-localhost [127.0.0.1])
        by mx1.idedalo.net (Postfix) with ESMTP id C918EBD8EB1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 19:27:04 +0200 (CEST)
Received: from mx1.idedalo.net ([127.0.0.1])
        by localhost (mx1.idedalo.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KdZTO44LxJKa for <linux-btrfs@vger.kernel.org>;
        Fri, 14 Sep 2018 19:27:04 +0200 (CEST)
Received: from [10.0.1.2] (s000002.idedalo.net [5.23.15.213])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ralcantara@idedalo.com)
        by mx1.idedalo.net (Postfix) with ESMTPSA id 59E8EBD8EA3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 19:27:04 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Rafael_Jes=c3=bas_Alc=c3=a1ntara_P=c3=a9rez?=
        <ralcantara@idedalo.com>
Subject: Problem with BTRFS
Message-ID: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
Date: Fri, 14 Sep 2018 19:27:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi:

After a power outage, my server refuses to mount a BTRFS file system.

This is the result of trying to mount with options recovery,ro:

BTRFS info (device sdc1): use lzo compression, level 0
BTRFS warning (device sdc1): 'recovery' is deprecated, use
'usebackuproot' instead
BTRFS info (device sdc1): trying to use backup root at mount time
BTRFS info (device sdc1): disk space caching is enabled
BTRFS info (device sdc1): has skinny extents
BTRFS error (device sdc1): super_total_bytes 6010266660864 mismatch with
fs_devices total_rw_bytes 6010266663424
BTRFS error (device sdc1): failed to read chunk tree: -22
BTRFS error (device sdc1): open_ctree failed

And this is the initial output of a "btrfs check --readonly":

  https://pastebin.com/6gs7hJTG

I'm planning to do a "btrfs recover fix-device-size" but I don't know if
it can be dangerous or if it's better to do a "btrfs check --repair" before.

Any recommendation?

Greets and thanks in advance.
Rafael J. Alcántara Pérez.
-- 
