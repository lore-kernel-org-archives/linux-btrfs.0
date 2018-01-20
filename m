Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:49483 "EHLO
        postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbeATKyv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Jan 2018 05:54:51 -0500
Received: from [192.168.0.1] (p5B0A3E0D.dip0.t-ipconnect.de [91.10.62.13])
        by postfix.iai.uni-bonn.de (Postfix) with ESMTP id D95625C40A
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Jan 2018 11:47:27 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to linux-btrfs@vger.kernel.org) (1)
        (internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
To: linux-btrfs@vger.kernel.org
From: Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Subject: Periodic frame losses when recording to btrfs volume with OBS
Message-ID: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
Date: Sat, 20 Jan 2018 11:47:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I would like to describe a real-world use case where btrfs does not 
perform well for me. I'm recording 60 fps, larger-than-1080p video using 
OBS Studio [1] where it is important that the video stream is encoded 
and written out to disk in real-time for a prolonged period of time (2-5 
hours). The result is a H264 video encoded on the GPU with a data rate 
ranging from approximately 10-50 MB/s.

The hardware used is powerful enough to handle this task. When I use a 
XFS volume for recording, no matter whether it's a SSD or HDD, the 
recording is smooth and no frame drops are reported (OBS has a nice 
Stats window where it shows the number of frames dropped due to encoding 
lag which seemingly also includes writing the data out to disk).

However, when using a btrfs volume I quickly observe severe, periodic 
frame drops. It's not single frames but larger chunks of frames that a 
dropped at a time. I tried mounting the volume with nobarrier but to no 
avail.

Of course, the simple fix is to use a FS that works for me(TM). However 
I thought since this is a common real-world use case I'd describe the 
symptoms here in case anyone is interested in analyzing this behavior. 
It's not immediately obvious that the FS makes such a difference. Also, 
if anyone has an idea what I could try to mitigate this issue (mount or 
mkfs options?) I can try that.

I saw this behavior on two different machines with kernels 4.14.13 and 
4.14.5, both Arch Linux. btrfs-progs 4.14, OBS 20.1.3-241-gf5c3af1b 
built from git.

Best regards
Sebastian

[1] https://github.com/jp9000/obs-studio
