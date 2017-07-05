Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751695AbdGEPa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jul 2017 11:30:26 -0400
Date: Wed, 5 Jul 2017 11:30:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Mason <clm@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/14] VFS: Don't use save/replace_mount_options if not
 using generic_show_options
Message-ID: <20170705113023.4dbbc3a6@gandalf.local.home>
In-Reply-To: <149926824918.20611.721200514474820755.stgit@warthog.procyon.org.uk>
References: <149926824154.20611.6104595541055328700.stgit@warthog.procyon.org.uk>
        <149926824918.20611.721200514474820755.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 05 Jul 2017 16:24:09 +0100
David Howells <dhowells@redhat.com> wrote:

> btrfs, debugfs, reiserfs and tracefs call save_mount_options() and reiserfs
> calls replace_mount_options(), but they then implement their own
> ->show_options() methods and don't touch s_options, rendering the saved  
> options unnecessary.  I'm trying to eliminate s_options to make it easier
> to implement a context-based mount where the mount options can be passed
> individually over a file descriptor.
> 
> Remove the calls to save/replace_mount_options() call in these cases.
> 

As this is patch 1/14, is there any dependency on this working? That
is, it is safe to simply remove this caller from those locations? Or
are there dependencies on having any of the 2-14 patches added to make
it not cause issues?

-- Steve
