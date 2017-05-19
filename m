Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34294 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755878AbdESJHx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 05:07:53 -0400
Received: by mail-oi0-f54.google.com with SMTP id b204so84784419oii.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 02:07:53 -0700 (PDT)
MIME-Version: 1.0
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 19 May 2017 02:07:11 -0700
Message-ID: <CAMp4zn8CfdzPn7UAHf7S2PT1F8ysf95jMi7F8RBUuyBvqYT5xw@mail.gmail.com>
Subject: QGroups Semantics
To: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have some questions about the *intended* qgroups semantics, and why
we allow certain operations:

1) Why can you create a level 0 qgroup for a non-existent subvolume?
It looks like it just gets reset when you create the subvol anyway?
Should we prevent this?

2) Why do we allow deleting a level 0 qgroup for a currently existing
subvolume? It seems to me that just setting the limit to 0, and/or
removing relations would work equally well? Perhaps a new ioctl to
clear the qgroup would make sense to do this.

3) Why don't we remove the associated level 0 qgroup when you remove
the subvol with that id?

4) I noticed in qgroup.c, one of the outstanding items is to determine
how to autocleanup. Are there any stated semantics around that, or
opinions?

PS:
If the answer to any of these is "it just needs to be worked on" --
I'm currently poking around this code path for some enhancements we're
doing for our usecase. I'm just trying to figure out how much of what
I'm doing is generalizable.

-Thanks,
Sargun
