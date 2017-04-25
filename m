Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:33400 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdDYECQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 00:02:16 -0400
Received: by mail-it0-f48.google.com with SMTP id 70so17751942ita.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Apr 2017 21:02:16 -0700 (PDT)
Received: from [192.168.0.23] ([98.4.97.1])
        by smtp.gmail.com with ESMTPSA id s40sm875161ite.18.2017.04.24.21.02.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Apr 2017 21:02:14 -0700 (PDT)
Message-ID: <58FECA45.1010107@gmail.com>
Date: Tue, 25 Apr 2017 00:02:13 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: backing up a collection of snapshot subvolumes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a remote machine with a filesystem for which I periodically take 
incremental snapshots for historical reasons.  These snapshots are 
stored in an archival filesystem tree on a file server.  Older snapshots 
are removed and newer ones added on a rotational basis.  I need to be 
able to backup this archive by syncing it with a set of backup drives. 
Due to the size, I need to back it up incrementally rather than sending 
the entire content each time.  Due to the snapshot rotation, I need to 
be able to update the state of the archive backup filesystem as a whole, 
in much the same manner that rsync handles file trees.

It seems that I cannot use "btrfs send", as the archive directory 
contains the snapshots as subvolumes.

I cannot use rsync as it treats subvolumes as simple directories, and 
does not preserve subvolume attributes.  Rsync also does not support 
reflinks, so the snapshot directory content will no longer be reflinked 
to other snapshots on the archive backup.  I cannot use hard links in 
the incrementals as hard links do not cross subvolume boundaries.

Thoughts anyone ?

