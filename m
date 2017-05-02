Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:33429 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdEBBuX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 21:50:23 -0400
Received: by mail-yw0-f170.google.com with SMTP id 203so62456184ywe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 May 2017 18:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170501180856.GH3516@merlins.org>
References: <20170501170641.GG3516@merlins.org> <20170501180856.GH3516@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 May 2017 19:50:22 -0600
Message-ID: <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, fdmanana@suse.com, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What about btfs check (no repair), without and then also with --mode=lowmem?

In theory I like the idea of a 24 hour rollback; but in normal usage
Btrfs will eventually free up space containing stale and no longer
necessary metadata. Like the chunk tree, it's always changing, so you
get to a point, even with snapshots, that the old state of that tree
is just - gone. A snapshot of an fs tree does not make the chunk tree
frozen in time.

To do what you want, maybe isn't a ton of work if it could be based on
a variation of the existing btrfs seed device code. Call it a "super
snapshot".

I like the idea of triage, where bad parts of the file system can just
be cut off, like triage. Compared to other filesystems, they'll say
this is hardware sabotage and nothing can be done. Btrfs is a bit
deceptive in that it sorta invites the idea we can use hardware that
isn't proven, and the fs can survive.

In any case, it's a big problem in my mind if no existing tools can
fix a file system of this size. So before making anymore changes, make
sure you have a btrfs-image somewhere, even if it's huge. The offline
checker needs to be able to repair it, right now it's all we have for
such a case.


Chris Murphy
