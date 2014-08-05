Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38870 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaHEWGE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 18:06:04 -0400
Received: by mail-ob0-f171.google.com with SMTP id wm4so1200579obc.16
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 15:06:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e464a0229fbd354aea0d15d8342330b1@admin.virtall.com>
References: <e464a0229fbd354aea0d15d8342330b1@admin.virtall.com>
Date: Tue, 5 Aug 2014 15:06:02 -0700
Message-ID: <CADw2B2MgvUt_bL11ZOAZjyk+R2pmM5JbLVjmgqoXBHSTEypMqw@mail.gmail.com>
Subject: Re: btrfs and iostat - how do I measure the live performance of my
 btrsf filesystems?
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 5, 2014 at 7:14 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Simple iostat won't give you meaningful live performance stats.
>
> You can combine it i.e. like below:
>
> iostat -x 1
> iostat -mx 1
> iostat -m 1

Thanks for the pointer about viewing the extended stats, and showing
them in MB rather than kB.

Maybe I'm missing something here. I'm failing to see how adding those
additional stats helps me get meaningful throughput information for a
multi-device btrfs volume.

-rb
