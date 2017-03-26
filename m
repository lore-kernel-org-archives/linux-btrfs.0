Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37511 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdCZDA4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Mar 2017 23:00:56 -0400
Received: by mail-it0-f43.google.com with SMTP id 190so23335537itm.0
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Mar 2017 20:00:22 -0700 (PDT)
Received: from [192.168.0.23] ([98.4.97.1])
        by smtp.gmail.com with ESMTPSA id e134sm3339337itc.23.2017.03.25.20.00.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 25 Mar 2017 20:00:21 -0700 (PDT)
Message-ID: <58D72EC4.9020101@gmail.com>
Date: Sat, 25 Mar 2017 23:00:20 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: backing up a file server with many subvolumes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a Btrfs filesystem on a backup server.  This filesystem has a 
directory to hold backups for filesystems from remote machines.  In this 
directory is a subdirectory for each machine.  Under each machine 
subdirectory is one directory for each filesystem (ex /boot, /home, etc) 
on that machine.  In each filesystem subdirectory are incremental 
snapshot subvolumes for that filesystem.  The scheme is something like 
this:

<top>/backup/<machine>/<filesystem>/<many snapshot subvolumes>

I'd like to try to back up (duplicate) the file server filesystem 
containing these snapshot subvolumes for each remote machine.  The 
problem is that I don't think I can use send/receive to do this. "Btrfs 
send" requires "read-only" snapshots, and snapshots are not recursive as 
yet.  I think there are too many subvolumes which change too often to 
make doing this without recursion practical.

Any thoughts would be most appreciated.

J. Hart

