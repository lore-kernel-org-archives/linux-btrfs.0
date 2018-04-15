Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from newman.cs.utexas.edu ([128.83.139.110]:55788 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbeDOBlp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 21:41:45 -0400
MIME-Version: 1.0
Reply-To: vijay@cs.utexas.edu
In-Reply-To: <20180415013015.GC21830@thunk.org>
References: <CA+EzBbCbRsZ=2qkBYjGVZQAVmUz34ky8vDOB7HxqRCrgymzysQ@mail.gmail.com>
 <CAOQ4uxhK6DQxTdipX2SP2t1960PrRt66+k3FVxQqwTBs-67cQA@mail.gmail.com>
 <CAPaz=E+-baGSWhL3nD-8X4jn6rKdn2AVGLeqWh3EY5Nh-RodRA@mail.gmail.com>
 <CAOQ4uxhRoAnxr36Cy1pov+ExnNJ8Y+inmUc7chD77ONPt=u9qw@mail.gmail.com>
 <CA+EzBbCFURDs77xiL3ECf7+4irrywbmD1HdsUSUYE_oeonbo8A@mail.gmail.com>
 <20180414012017.GF5572@dastard> <CAPaz=EJrOc7dBE+gBf=Gx0W-4_q0GwTrRhchquPveWs-m-Djeg@mail.gmail.com>
 <20180414215529.GG5572@dastard> <CAPaz=ELn5GNbw4z5e30Og1ExyRTFNxHhPM9K_qn-EKWQ_Y7jXQ@mail.gmail.com>
 <20180415013015.GC21830@thunk.org>
From: Vijay Chidambaram <vijay@cs.utexas.edu>
Date: Sat, 14 Apr 2018 20:40:34 -0500
Message-ID: <CAPaz=ELfcQVgjh7pkWKtvL5muqFcJHvCrSaGoBAE+Q6RnK93-g@mail.gmail.com>
Subject: Re: Symlink not persisted even after fsync
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>,
        Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ted,

On Sat, Apr 14, 2018 at 8:30 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> When you open "foo", the restulting file descriptor is not associated
> with the symlink.  The resulting file descriptor is the exact same
> thing you would get if you had instead called:
>
>         fd = open("/tmp/bar/quux", O_CREAT|O_RDWR);
>
> Hence, when you call
>
>        fsync(fd);
>
> What you are calling fsync on is not the _symlink_, but the inode
> which is named by /tmp/bar/quux.

Thank you! This was the crucial misunderstanding on our part. The
behavior makes a lot more sense now.
