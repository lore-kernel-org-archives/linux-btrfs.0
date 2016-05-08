Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35783 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbcEHS2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 14:28:17 -0400
Received: by mail-lf0-f67.google.com with SMTP id u64so18906834lff.2
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 11:28:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it> <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it> <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com> <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sun, 8 May 2016 20:27:55 +0200
Message-ID: <CAA7pwKNEwFvktQbpjAPE2TZzT4nYfapNbLSR+rgyrUmyJhvsWw@mail.gmail.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 May 2016 at 18:11, Niccolò Belli <darkbasic@linuxsystems.it> wrote:

> Which kind of hardware issue? I did a full memtest86 check, a full smartmontools extended check and even a badblocks -wsv.
> If this is really an hardware issue that we can identify I would be more than happy because Dell will replace my laptop and this nightmare will be finally over. I'm open to suggestions.


Well, your hardware differs from a lot of successful installations.
Are you using any power management tweaks?
