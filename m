Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59812 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754562AbdKAOJm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 10:09:42 -0400
Date: Wed, 1 Nov 2017 15:07:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Nick Terrell <terrelln@fb.com>
Cc: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix default compression value when set by
 SETFLAGS ioctl
Message-ID: <20171101140751.GE3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171031164551.6447-1-dsterba@suse.com>
 <6D6419B4-89D2-4581-8776-726007201343@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6D6419B4-89D2-4581-8776-726007201343@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 07:21:59PM +0000, Nick Terrell wrote:
> On 10/31/17, 9:48 AM, "David Sterba" <dsterba@suse.com> wrote:
> > The current default for the compression file flag is 'zlib', the zstd
> > patch silently changed that to zstd. Though the choice of zlib might not
> > be the best one, we should keep the backward compatibility.
> 
> Sorry about that, I didn't intentionally change it. I checked over my patch,
> and the only other place where an "else" was changed is the other place in
> ioctl.c, which looks okay to me.
> 
> I'm trying to expose the buggy case in 4.14-rc7. However, since
> fs_info->compress_type defaults to ZLIB when -compress is not passed, and
> when -compress=no is passed, fs_info->compress_type is not modified, I
> don't know how to get fs_info->compress_type to be BTRFS_COMPRESS_NONE.
> Is there a way that fs_info->compress_type can be BTRFS_COMPRESS_NONE?

And it turns out that this is not possible, fs_info::compress_type will
always be one of lzo/zlib/zstd. This is zlib by default, so any chattr +c
will set zlib. In order to set zstd by chattr, there would have to be at
least one mount with zstd or defrag -czstd. And this will set the
incompat bit.

> I modified -compress=no to set fs_info->compress_type=BTRFS_COMPRESS_NONE
> and the ioctl() call set the compression type to zstd before your patch,
> and zlib after, as expected.

I must have assumed that mounting with -o compress=no will reset the
compress_type. So unless I missed something else, the default will not
change and the feature flags match the actual filesystem state. False
alert, sorry. At least I don't have to send a late pull request.
