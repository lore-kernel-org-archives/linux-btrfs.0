Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:32885 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbdENXBo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 19:01:44 -0400
Received: by mail-wr0-f173.google.com with SMTP id w50so70064443wrc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 May 2017 16:01:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de> <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
 <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com> <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 15 May 2017 01:01:42 +0200
Message-ID: <CAK5rZE7MKrqNSuJXTYe=H_T6WbYJgcGhV9VUHH0pQ689-tKiAg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/14/17, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
> In terms of over provisioning of SSD it’s a give and take relationship … on
> good drive there is enough over provisioning to allow a normal operation on
> systems without TRIM … now if you would use a 1TB drive daily without TRIM
> and have only 30GB stored on it you will have fantastic performance but if
> you will want to store 500GB at roughly 200GB you will hit a brick wall and
> you writes will slow dow to megabytes / s … this is symptom of drive running
> out of over provisioning space …

What exactly happens on a non-trimmed drive?
Does it begin to forge certain erase-blocks? If so
which are those? What happens when you never
trim and continue dumping data on it?
