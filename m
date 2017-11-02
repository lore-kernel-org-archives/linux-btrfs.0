Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:47513 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754859AbdKBJJp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 05:09:45 -0400
Received: by mail-wm0-f54.google.com with SMTP id r196so9455462wmf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 02:09:45 -0700 (PDT)
Message-ID: <1509613781.1662.115.camel@gmail.com>
Subject: Re: Several questions regarding btrfs
From: ST <smntov@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 02 Nov 2017 11:09:41 +0200
In-Reply-To: <7e8d6430-01e0-ba8e-5822-510ba1daef9f@gmail.com>
References: <1509467017.1662.37.camel@gmail.com>
         <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
         <1509480384.1662.84.camel@gmail.com>
         <ea097624-d485-9423-387f-3c9427508883@gmail.com>
         <1509545153.1662.105.camel@gmail.com>
         <7e8d6430-01e0-ba8e-5822-510ba1daef9f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >>>
> >>> Ok. I'll use more standard approaches. Which of following commands will
> >>> work with BTRFS:
> >>>
> >>> https://debian-handbook.info/browse/stable/sect.quotas.html
> >> None, qgroups are the only option right now with BTRFS, and it's pretty
> >> likely to stay that way since the internals of the filesystem don't fit
> >> well within the semantics of the regular VFS quota API.  However,
> >> provided you're not using huge numbers of reflinks and subvolumes, you
> >> should be fine using qgroups.
> > 
> > I want to have 7 daily (or 7+4) read-only snapshots per user, for ca.
> > 100 users. I don't expect users to invoke cp --reflink or take
> > snapshots.
> Based on what you say below about user access, you should be absolutely 
> fine then.
> 
> There's one other caveat though, only root can use the qgroup ioctls, 
> which means that only root can check quotas.

Only root can check quotas?! That is really strange. How users are
supposed to know they are about to be out of space?... Is this by design
so and will remain like that or it's just because this feature was not
finished yet?

