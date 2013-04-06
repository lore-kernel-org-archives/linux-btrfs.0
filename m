Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56504 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161113Ab3DFVun (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 17:50:43 -0400
Date: Sat, 6 Apr 2013 22:50:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Steve French <sfrench@samba.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Anton Altaparmakov <anton@tuxera.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        Matthew Wilcox <matthew@wil.cx>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] fsfreeze: manage kill signal when sb_start_write is
 called
Message-ID: <20130406215033.GM4068@ZenIV.linux.org.uk>
References: <515FF344.8040705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515FF344.8040705@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 06, 2013 at 12:04:52PM +0200, Marco Stornelli wrote:
> In every place where sb_start_write was called now we must manage
> the error code and return -EINTR.

Now go and look for callers of mnt_want_write() ;-/  The really
painful one is in do_last(), but kern_path_create() is not much
better; mq_open() would be bad too, had it not been about something
you are not going to freeze anyway...
