Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54165 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752642AbdCAQNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 11:13:42 -0500
Date: Wed, 1 Mar 2017 15:59:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Benedikt Morbach <benedikt.morbach@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: send-dump: add missing newlines
Message-ID: <20170301145955.GE4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170222213246.29315-1-benedikt.morbach@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170222213246.29315-1-benedikt.morbach@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 22, 2017 at 10:32:46PM +0100, Benedikt Morbach wrote:
> make sure to include newlines after commands that have only one
> argument, such as 'unlink' or 'mkfile'
> 
> changes
> 
>     unlink          ./baz.0/file_autimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
>     truncate        ./baz.0/file_a                  size=131072
>     chmod           ./baz.0/file_a                  mode=644
>     utimes          ./baz.0/file_a                  atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
>     mkfile          ./baz.0/o258-11-0rename          ./baz.0/o258-11-0               dest=./baz.0/file_b
>     utimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
> 
> to
> 
>     unlink          ./baz.0/file_a
>     utimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
>     truncate        ./baz.0/file_a                  size=131072
>     chmod           ./baz.0/file_a                  mode=644
>     utimes          ./baz.0/file_a                  atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
>     mkfile          ./baz.0/o258-11-0
>     rename          ./baz.0/o258-11-0               dest=./baz.0/file_b
>     utimes          ./baz.0/                        atime=2017-02-22T11:59:16+0100 mtime=2017-02-22T11:59:16+0100 ctime=2017-02-22T11:59:16+0100
> 
> Signed-off-by: Benedikt Morbach <benedikt.morbach@googlemail.com>

Applied, thanks.
