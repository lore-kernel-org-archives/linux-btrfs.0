Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38040 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933197AbdDFQ01 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Apr 2017 12:26:27 -0400
Date: Thu, 6 Apr 2017 12:26:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eryu Guan <eguan@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Message-ID: <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170405023526.GS22845@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170405023526.GS22845@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 05, 2017 at 10:35:26AM +0800, Eryu Guan wrote:
> 
> Test fails with ext3/2 when driving with ext4 driver, fiemap changed
> after umount/mount cycle, then changed back to original result after
> sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)

I haven't had time to look at this, but I'm not sure this test is a
reasonable one on the face of it.

A file system may choose to optimize a file's extent tree for whatever
reason it wants, whenever it wants, including on an unmount --- and
that would not be an invalid thing to do.  So to have an xfstests that
causes a test failure if a file system were to, say, do some cleanup
at mount or unmount time, or when the file is next opened, to merge
adjacent extents together (and hence change what is returned by
FIEMAP) might be strange, or even weird --- but is this any of user
space's business?  Or anything we want to enforce as wrong wrong wrong
by xfstests?

		       		   	   - Ted
					   
