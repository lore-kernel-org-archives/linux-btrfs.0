Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753687AbdGLP60 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 11:58:26 -0400
Date: Wed, 12 Jul 2017 17:57:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH 00/19] fs_info refactor part 2 (disk-io.h and volumes.h
 based)
Message-ID: <20170712155701.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
 <41aa56a9-075b-7107-25cf-4673ecabc3e0@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <41aa56a9-075b-7107-25cf-4673ecabc3e0@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 05:11:16PM +0800, Qu Wenruo wrote:
> Any comment?

Patches applied, sorry for the delay.

> 在 2017年06月13日 17:19, Qu Wenruo 写道:
> > This is the part 2 patchset to refactor btrfs_root usage to
> > btrfs_fs_info.
> >
> > The most obvious advantage is to make function calls a little shorter,
> > and less confused.
> > Function calls like btrfs_alloc_data_chunk() needs caller to pass a
> > btrfs_root parameter, while the parameter should always be
> > fs_info->extent_root, grab it inside that function is much more safer
> > than allowing user to pass in a random root.
> >
> > Another advantage is to make it easier to sync some headers with kernel.
> > In fact, when I'm not sure if I should convert one function, I normally
> > check kernel code to find the parameter of kernel equivalent.
> > So when we are going to sync (part of) the headers with kernel, it will
> > reduce the work.
> >
> > Part 2 focus on the exported functions mainly in disk-io.h and
> > volumes.h.
> > Now most tree blocks/extents read/write, device scan/read, chunk
> > allocation/initialization functions are all using fs_info.
> >
> > I'm quite sure there is a lot of remaining functions to be refactored,
> > but I prefer to do it step by step.

Yes, this would be better.
