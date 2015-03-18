Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33363 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbbCRPgS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 11:36:18 -0400
Received: by wixw10 with SMTP id w10so65905606wix.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 08:36:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Mar 2015 16:36:17 +0100
Message-ID: <CAC-qVGA-F=8pNcp+zRvQqd5=ag67Ykb2BVYLzLb1Wtp7zqYW0Q@mail.gmail.com>
Subject: Is btrfs filesystem resize synchronous?
From: =?UTF-8?Q?Zolt=C3=A1n_Halassy?= <cf0hay@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it safe to use do something like this:

# btrfs filesystem resize 100m /mnt/something && lvreduce -f -L100M
/dev/somevg/somelv

as in, when the first command exits with 0 status, is the filesystem
already resized? I mean, it's 100% sure the FS driver will not touch
any blocks beyond the requested size after the resize successfully
returned? I guess the utility just signals some ioctl to the mounted
filesystem, but I wonder if the ioctl only returns successfully when
it finished the task.

Sorry if this is a noise, I didn't find anything about this in the
user documentation, and it is not obvious for me. I read somewhere,
the FS driver does not check for missing blocks at the end of the
device during mount (eg, when the device is smaller than the reported
size in the superblock), and will simply throw io errors when tries to
access those blocks. This made me ask the question above.
