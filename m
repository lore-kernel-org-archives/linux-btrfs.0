Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49641 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752681AbcIVQF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 12:05:58 -0400
Date: Thu, 22 Sep 2016 18:03:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 00/14] Btrfsck low memory mode with fs/subvol tree
 check
Message-ID: <20160922160356.GS16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 11:15:50AM +0800, Qu Wenruo wrote:
> The branch can be fetched from my github:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fs_tree

I've put it into integration but haven't reviewed nor tested it.

> Already merged lowmem mode fsck only works for extent/chunk tree check.
> And for fs tree, it's still using original mode codes.
> 
> This makes btrfs check still eat tons of memory for large fs.
> 
> Now the new lowmem mode code will also cover fs tree now, to make
> lowmem mode be really low-memory usage mode.
> 
> And the whole patchset goes through the whole fsck test cases, except
> the following case:
> 
> 006: There is a bug in root item repair code, causing backref error.
>      However old fsck has another bug to overwrite extent tree error,
>      so old fsck will only report error but still return 0.
> 
>      That's an unrelated btrfsck repair bug, which I'll address it later.
> 
> 015: Just wrong test cases. It's not a normal check-repair-check one.
>      So the check after repair will still report error.
>      Better to put it to fuzz test cases.
> 
> Further plan for lowmem mode is:
> 1) Add support for --repair
>    A lot of work again.
> 
> 2) Separate original and lowmem mode codes into different files
>    300+K single source is really too large.
>    Better separate them into a dir and multiple files

Makes sense. We're about to split the files by other criteria (kernel,
etc) so this will possible once the details are fleshed out.
