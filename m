Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52019 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3C0JHq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 05:07:46 -0400
Received: by mail-ob0-f182.google.com with SMTP id ef5so5322018obb.41
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 02:07:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
References: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
Date: Wed, 27 Mar 2013 10:07:45 +0100
Message-ID: <CAFvQSYT3D89LNsN_7EcnM9fH7JpwUCm8KWDjvUjGXQdT3-Cxxw@mail.gmail.com>
Subject: Re: "No space left on device" although df reports only 55% in use
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

I wonder if this is the intended behaviour or some known issue?
Otherwise I could provide a tool written by a friend of mine which can
trigger this issue within a few minutes on a a fresh btrfs partition.
Its basically a file-system aging tester, which replays some
real-world logs taken from NFS file servers.

Regards, Clemens
