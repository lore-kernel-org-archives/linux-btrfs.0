From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: check if qa user can execute commands
Date: Tue, 6 Dec 2011 10:18:09 -0500
Message-ID: <20111206151809.GA15526@infradead.org>
References: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
 <20111206151300.GA11874@infradead.org>
 <4EDE31DD.3000401@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Jan Schmidt <mail@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EDE31DD.3000401@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 06, 2011 at 04:16:45PM +0100, Jan Schmidt wrote:
> I agree. I saw this and thought I'd adapt the (sometimes strange)
> predominant bash programming style:

Maybe the IRIX su command didn't support -c.  I'll put your patch in
as-is.

