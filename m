Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:51306 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753776AbdKNMyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:54:54 -0500
Received: by mail-wm0-f51.google.com with SMTP id b189so14887092wmd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 04:54:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 14 Nov 2017 13:54:32 +0100
Message-ID: <CAA7pwKNKisMoZgBZN_7zOr7oG6MJQCcXtpQ5kOxB_moEhw+ZJQ@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 November 2017 at 09:36, Klaus Agnoletti <klaus@agnoletti.dk> wrote:
>
> How do you guys think I should go about this?

I'd clone the disk with GNU ddrescue.

https://www.gnu.org/software/ddrescue/
