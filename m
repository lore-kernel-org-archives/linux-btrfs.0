Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:41801 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932368AbeFGRDo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 13:03:44 -0400
Received: by mail-pl0-f66.google.com with SMTP id az12-v6so6510390plb.8
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 10:03:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0dff7b42-65d2-a29e-2086-938031859004@oracle.com>
References: <000000000000832e70056df8fb38@google.com> <0dff7b42-65d2-a29e-2086-938031859004@oracle.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 7 Jun 2018 19:03:23 +0200
Message-ID: <CACT4Y+Yv4_TjyJtNxso9CLBZPXCUkYZy_1RG_o6ASJdTsLO2Ng@mail.gmail.com>
Subject: Re: general protection fault in open_fs_devices
To: Anand Jain <anand.jain@oracle.com>
Cc: syzbot <syzbot+909a5177749d7990ffa4@syzkaller.appspotmail.com>, clm@fb.com,
        dsterba@suse.com, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 6, 2018 at 6:28 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
> On 06/06/2018 09:17 PM, syzbot wrote:
>
>
>
>  Which means there was some other thread which freed our %fs_devices.
>  As this thread is still in open_ctree() so the contending thread can't
>  be the ioctl(). So btrfs_free_stale_devices() is the only thread which
>  can free our %fs_devices in this case.
>
>  This is fixed in [1] in the mailing list.
>
>  [1]
>    [PATCH 3/3] btrfs: fix race between mkfs and mount


Let's tell about this syzbot:

#syz fix: btrfs: fix race between mkfs and mount
