From: David Brown <davidb@davidb.org>
Subject: Re: [patch 01/99] btrfs: Add btrfs_panic()
Date: Wed, 23 Nov 2011 18:05:33 -0800
Message-ID: <20111124020533.GA14982@davidb.org>
References: <20111124003533.395674389@suse.com>
 <20111124004219.933819241@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124004219.933819241@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2011 at 07:35:34PM -0500, Jeff Mahoney wrote:
> As part of the effort to eliminate BUG_ON as an error handling
> technique, we need to determine which errors are actual logic errors,
> which are on-disk corruption, and which are normal runtime errors
> e.g. -ENOMEM.
>
> Annotating these error cases is helpful to understand and report them.
>
> This patch adds a btrfs_panic() routine that will either panic
> or BUG depending on the new -ofatal_errors={panic,bug} mount option.
> Since there are still so many BUG_ONs, it defaults to BUG for now but I
> expect that to change once the error handling effort has made
> significant progress.

Any reason all of the commit text is indented in this series?

David
