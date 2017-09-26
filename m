Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:53472 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753951AbdIZPCV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 11:02:21 -0400
Received: by mail-qk0-f173.google.com with SMTP id t184so10339740qke.10
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:02:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ_hD5Dw0H+2c0qztzUc2kEhZZ-PbRTMpzR+R_isQ_S0ph99iQ@mail.gmail.com>
References: <CAJ_hD5Dw0H+2c0qztzUc2kEhZZ-PbRTMpzR+R_isQ_S0ph99iQ@mail.gmail.com>
From: Eric Wolf <19wolf@gmail.com>
Date: Tue, 26 Sep 2017 11:02:00 -0400
Message-ID: <CAJ_hD5Af8YLw_Q0XOC4LLN+=HKKg7oSj+ide1sm4Sr2b7Qq1YA@mail.gmail.com>
Subject: Re: rm: it is dangerous to operate recursively on '/data/Backup/@'
 (same as '/')
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So somehow my @ and @home subvolumes became mounted at /data/Backup in
addition to their normal locations (/ and /home). So when I used 'dd'
I was outputting to my OS drive instead of my data pool. How did this
happen? How do I undo it? I'll try restarting now, but I'll await
further responses before replying to myself again.
---
Eric Wolf
(201) 316-6098
19wolf@gmail.com


On Tue, Sep 26, 2017 at 10:41 AM, Eric Wolf <19wolf@gmail.com> wrote:
> I accidentally filled my OS drive with a copy of itself? The problem
> is, /data/ is a separate pool from the OS drive. And now it looks like
> I can't erase it? I don't even know how I got here. All I did was "dd
> if=/dev/sda of=/data/Backup/backup-new.img && mv
> /data/Backup/backup-new.img /data/Backup/backup.img" I don't really
> know where to go from here.
