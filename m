Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37224 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbcDRPj0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 11:39:26 -0400
Received: by mail-ig0-f174.google.com with SMTP id g8so83285043igr.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 08:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5714FA2F.6010207@gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<5714D39B.90402@gmail.com>
	<CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
	<5714FA2F.6010207@gmail.com>
Date: Mon, 18 Apr 2016 09:39:24 -0600
Message-ID: <CAJCQCtTSdnD+n9UR7hWtqLdBzjb6WQXF71XKTgKJNgZPcdA3fg@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Alcorn <nroclaed@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 9:15 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
>>
> I don't know about the current state of the Debian installer, but I know
> back when I used Debian regularly and used the standard text based
> installer, as long as I didn't format things from the UI, I could provision
> the filesystems however the hell I wanted manually and point the installer
> at the appropriate ones for each mount point, and it worked.

No doubt this is a catch 22. I think it's reasonable for an installer
to have an aging logic that allows it to be more conservative than the
kernel's support for compat_ro_flags and incompat_flags, and refuse to
install if it's not recently formatted.

Now that I go look for this, I'm not sure what either flags offset
0x38 or compat_flags offset 0xac are about.

Also, I didn't mention that Anaconda does require root fs to be in a
new subvolume. It won't install to either subvolid 5, or any other
existing subvolume.

-- 
Chris Murphy
