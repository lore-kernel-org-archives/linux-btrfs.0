Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:34719 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbcH0N5U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Aug 2016 09:57:20 -0400
Received: by mail-ua0-f181.google.com with SMTP id k90so181343037uak.1
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Aug 2016 06:57:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160826190259.GB1470521@mother.pipebreaker.pl>
References: <CAJtFHUSSEd0ABBRi1-Ko4ciu+-tr62KvkBDVRc4zYf8PF_g4cA@mail.gmail.com>
 <20160826190259.GB1470521@mother.pipebreaker.pl>
From: E V <eliventer@gmail.com>
Date: Sat, 27 Aug 2016 09:57:04 -0400
Message-ID: <CAJtFHUS0qj9YeiDrcFLaWdprHYAk+ye9CQwZQ-UBmwgY96J-dw@mail.gmail.com>
Subject: Re: linux 4.7.2 & btrfs & rsync & OOM gone crazy
To: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OOM killer still killed rsync with swappiness 0, so rebuilt and
rebooted with the patch and restarted the rsync. Seems to be running
fine atm. Cached mem shoots right up to almost all of RAM and stays
there per usual. We'll see how it goes.

On Fri, Aug 26, 2016 at 3:02 PM, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> On Fri, Aug 26, 2016 at 03:00:48PM -0400, E V wrote:
>> Just upgraded from 4.6.5 to 4.7.2 for my btrfs backup server with 32GB
>> of ram. Only thing that run's on it is an rsync of an NFS filesystem
>> to the local btrfs. Cached mem tends to hang out around 26-30GB, but
>> with 4.7.2 the OOM is now going crazy and trying to kill whatever it
>> can including my ssh and rsync process. Anyone seen anything similar?
>
>   That's probably OOM regression in 4.7. Could you please test this patch:
> https://lkml.org/lkml/2016/8/23/145
>
> --
> Tomasz Torcz              ,,If you try to upissue this patchset I shall be seeking
> xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew Morton (LKML)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
