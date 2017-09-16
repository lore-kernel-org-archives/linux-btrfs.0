Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51962 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdIPM1I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 08:27:08 -0400
Subject: Re: Regarding handling of file renames in Btrfs
To: Rohan Kadekodi <kadekodirohan@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>,
        Jayashree Mohan <jayashree2912@gmail.com>
References: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <a2bf5d89-6753-2893-2dac-89fcbc924096@mendix.com>
Date: Sat, 16 Sep 2017 14:27:04 +0200
MIME-Version: 1.0
In-Reply-To: <CADb0YN=G1MT=VwLcfbbrnppeXRKe3Zi4EsmwSs+xw89wR9rb4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/10/2017 01:50 AM, Rohan Kadekodi wrote:
> 
> I was trying to understand how file renames are handled in Btrfs. I
> read the code documentation, but had a problem understanding a few
> things.
> 
> During a file rename, btrfs_commit_transaction() is called which is
> because Btrfs has to commit the whole FS before storing the
> information related to the new renamed file.

Can you point to which lines of code you're looking at?

> It has to commit the FS
> because a rename first does an unlink, which is not recorded in the
> btrfs_rename() transaction and so is not logged in the log tree. Is my
> understanding correct? [...]

Can you also point to where exactly you see this happening? I'd also
like to understand more about this.

The whole mail thread following this message continues about what a
transaction commit is and does etc, but the above question is never
answered I think.

And I think it's an interesting question. Is a rename a "heavier"
operation relative to other file operations?

-- 
Hans van Kranenburg
