Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:55108 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757449AbdJMMGM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 08:06:12 -0400
Received: by mail-lf0-f53.google.com with SMTP id d10so9364852lfg.11
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 05:06:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2aa3b$47885ead$d44bbe7e$37d6c337@cox.net>
References: <CAC+fKQXPGpwuhVz7oNLzPLd0ydo+kiqG1vpcWvx+-DZ+2jL6Bg@mail.gmail.com>
 <pan$2aa3b$47885ead$d44bbe7e$37d6c337@cox.net>
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Fri, 13 Oct 2017 14:06:10 +0200
Message-ID: <CAC+fKQUZtA+tY-97DwDH7atN8VoKkWPjkhMBTGKH7dzyp_H1Ng@mail.gmail.com>
Subject: Re: Btrfs warnings in kernel 4.13.5
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-13 13:02 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> Those warnings aren't anything to be /too/ worried about.  They are
> triggered when a btrfs device size isn't a multiple of the btrfs
> sectorsize (currently 4 KiB on amd64 aka x86_64).  You can manually
> shrink your btrfs devices the fraction to an exact 4 KiB multiple, or
> wait a bit, and a new release of btrfs-tools should have a command to do
> it for you.


Thanks.
