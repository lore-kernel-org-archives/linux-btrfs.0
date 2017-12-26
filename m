Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:45665 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdLZHLP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Dec 2017 02:11:15 -0500
Received: by mail-ua0-f193.google.com with SMTP id e39so879581uae.12
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Dec 2017 23:11:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b70cd6d9-c1e6-29f1-a96f-711edeb37261@gmx.com>
References: <20171222061847.13158-5-wqu@suse.com> <20171226053727.25505-1-wqu@suse.com>
 <b70cd6d9-c1e6-29f1-a96f-711edeb37261@gmx.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 26 Dec 2017 12:40:34 +0530
Message-ID: <CAKuJGC_=XApqf3n0H4-aFGpJhbeyczy3_h72CXpOqPVeBz06nw@mail.gmail.com>
Subject: Re: [PATCH v2.2 04/10] btrfs: qgroup: Use separate meta reservation
 type for delalloc
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, btrfs <linux-btrfs@vger.kernel.org>,
        dsterba <dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> And for anyone who wants to test the latest version of the patchset, it
> can be fetched from the following branch:

I started a build with qgroup_meta_rework from [0] and its currently
running [1],
will update the results  once it completes in few hours time.

[0]: https://github.com/adam900710/linux :
[1]: http://btrfs.in:3000/r/Lakshmipathi

----
Cheers,
Lakshmipathi.G
