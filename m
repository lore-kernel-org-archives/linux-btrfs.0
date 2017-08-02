Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35129 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdHBWW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 18:22:29 -0400
Received: by mail-wm0-f42.google.com with SMTP id m85so965400wma.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 15:22:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 2 Aug 2017 16:22:27 -0600
Message-ID: <CAJCQCtRywY4iZnexCHRyToaZkBi=Ot3Cft3Q_6fGBorrAfaB+A@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 2, 2017 at 2:38 AM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
> The title seems alarmist to me - and I suspect it is going to be
> misconstrued. :-/

Josef pushed bak on the HN thread with very sound reasoning about why
this is totally unsurprising. RHEL runs old kernels, and they have no
upstream Btrfs developers. So it's a huge PITA to backport the tons of
changes Btrfs has been going through (thousands of line changes per
kernel cycle).

What's more interesting to me is whether this means
-  CONFIG_BTRFS_FS=m
+  # CONFIG_BTRFS_FS is not set

In particular in elrepo.org kernels.

Also more interesting is this Stratis project that started up a few months ago:

https://github.com/stratis-storage/stratisd

Which also includes this design document:
https://stratis-storage.github.io/StratisSoftwareDesign.pdf

Basically they're creating a file system manager manifesting as a
daemon, new CLI tools, and new metadata formats for the volume
manager. So it's going to use existing device mapper, md, some LVM
stuff, XFS, in a layered approach abstracted from the user.

-- 
Chris Murphy
