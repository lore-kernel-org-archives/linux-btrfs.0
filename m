Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44903 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbeIGU1v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 16:27:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id g6-v6so12376409lfb.11
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 08:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 7 Sep 2018 09:46:19 -0600
Message-ID: <CAJCQCtSSAhjWXOS1X8A-q0qtOZ2MBHoUWyHvhWino0K5TqBanw@mail.gmail.com>
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
To: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 7, 2018 at 3:56 AM, Jürgen Herrmann <t-5@t-5.eu> wrote:
> Hello!
>
> I'm having a problem with btrfs send which stops after several seconds.
> The process hangs with 100% cpu time on one cpu. The system is still
> responsive to input but no io is happening anymore so the system
> basically becomes unuseable.

What kernel? Latest stable is 4.18.6. but I want to make sure that's
what you're using, someone else has reported btrfs send problems in
another thread with 4.18.5 that sound similar.




-- 
Chris Murphy
