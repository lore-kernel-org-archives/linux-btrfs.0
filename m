Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36277 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPUgf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 15:36:35 -0500
Received: by mail-yw0-f178.google.com with SMTP id v200so14100054ywc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2017 12:36:35 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 16 Feb 2017 13:36:34 -0700
Message-ID: <CAJCQCtSo7nrgU4jkr85vm+4S9iwyoLF_USjZ4DTbd__-a62qGg@mail.gmail.com>
Subject: man filesystems(5) doesn't contain Btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This man page contains a list for pretty much every other file system,
with a oneliner description: ext4, XFS is in there, and even NTFS, but
not Btrfs.

Also, /etc/filesystems doesn't contain Btrfs. Anyone know if either,
or both, ought to contain an entry for Btrfs?

-- 
Chris Murphy
