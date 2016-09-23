Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33782 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034081AbcIWCE5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 22:04:57 -0400
Received: by mail-oi0-f47.google.com with SMTP id r126so119292197oib.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 19:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSJhXdERkSByMfQq8gas5ESZJviB6-xa5tYc2aM4MJSZQ@mail.gmail.com>
References: <CAJCQCtSJhXdERkSByMfQq8gas5ESZJviB6-xa5tYc2aM4MJSZQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 22 Sep 2016 20:04:56 -0600
Message-ID: <CAJCQCtQE1ZoJ6hiwd6aeCQszDLkJ1w-M4=yD7yXtqX9boNcqng@mail.gmail.com>
Subject: Re: btrfs subvolume list and show disagree on generation
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 8:03 PM, Chris Murphy <lists@colorremedies.com> wrote:

> [chris@f24s first]$ sudo btrfs sub list -t /brick2
> ID    gen    top level    path
> --    ---    ---------    ----
> 1208    8019    5        everything-20160218

[...snip...]

> [chris@f24s first]$ sudo btrfs sub show everything-20160218
> /mnt/first/everything-20160218
>     Name:             everything-20160218
>     UUID:             snip
>     Parent UUID:         snip
>     Received UUID:         -
>     Creation time:         2016-02-18 21:24:03 -0700
>     Subvolume ID:         673
>     Generation:         1759
>     Gen at creation:     1007
>     Parent ID:         5
>     Top level ID:         5
>     Flags:             readonly
>     Snapshot(s):

Why does 'show' say Subvolume ID is 673 but 'list' says the ID is 1208?




-- 
Chris Murphy
