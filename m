Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36477 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753890AbdGJQQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 12:16:27 -0400
Date: Mon, 10 Jul 2017 18:15:12 +0200
From: David Sterba <dsterba@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        reiserfs-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/14] VFS: Don't use save/replace_mount_options if not
 using generic_show_options
Message-ID: <20170710161512.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <149926824154.20611.6104595541055328700.stgit@warthog.procyon.org.uk>
 <149926824918.20611.721200514474820755.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <149926824918.20611.721200514474820755.stgit@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 05, 2017 at 04:24:09PM +0100, David Howells wrote:
> btrfs, debugfs, reiserfs and tracefs call save_mount_options() and reiserfs
> calls replace_mount_options(), but they then implement their own
> ->show_options() methods and don't touch s_options, rendering the saved
> options unnecessary.  I'm trying to eliminate s_options to make it easier
> to implement a context-based mount where the mount options can be passed
> individually over a file descriptor.
> 
> Remove the calls to save/replace_mount_options() call in these cases.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Chris Mason <clm@fb.com>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: Steven Rostedt <rostedt@goodmis.org>
> cc: linux-btrfs@vger.kernel.org
> cc: reiserfs-devel@vger.kernel.org
> ---

For

>  fs/btrfs/super.c    |    1 -

Acked-by: David Sterba <dsterba@suse.com>
