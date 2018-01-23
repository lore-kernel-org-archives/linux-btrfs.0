Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:45693 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbeAWUTV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 15:19:21 -0500
Received: by mail-qt0-f177.google.com with SMTP id x27so4676922qtm.12
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 12:19:21 -0800 (PST)
Date: Tue, 23 Jan 2018 15:19:19 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Mike Gilbert <floppymaster@gmail.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: btrfs directory listing temporarily includes a recently removed
 file
Message-ID: <20180123201918.melolhao4ll6uyhq@destiny>
References: <CAJ0EP42wcb4uQQ-qivb38ZAYR8_+3k9fD+pDrj1cRZ_uVzdVvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ0EP42wcb4uQQ-qivb38ZAYR8_+3k9fD+pDrj1cRZ_uVzdVvg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 12:11:00PM -0500, Mike Gilbert wrote:
> Hi all,
> 
> I just wanted to draw some attention to a recent regression regarding
> a race condition when listing directories on btrfs. Your assistance in
> resolving this would be appreciated.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=198483

Sorry about that, I've posted a patch for it.  Thanks,

Josef
