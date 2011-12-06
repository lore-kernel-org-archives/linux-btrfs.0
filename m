From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: check if qa user can execute commands
Date: Tue, 6 Dec 2011 10:13:00 -0500
Message-ID: <20111206151300.GA11874@infradead.org>
References: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2011 at 10:56:29AM +0100, Jan Schmidt wrote:
> _require_user only checks if the qa user exists in /etc/passwd. It may exist
> though still not be able to execute anything (e.g. with a /bin/false shell).
> 
> _user_do cannot determine failure to execute the given command, as it uses
> _user_do_filter for post-processing which succeeds even if the command
> fails. Thus, the check should be performed by _require_user.

Looks good.  Wouldn't

	su $qa_user -c /bin/true

be the more normal way to write that test?

