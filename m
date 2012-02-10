From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4] Generic O_SYNC AIO DIO handling
Date: Fri, 10 Feb 2012 11:09:09 -0500
Message-ID: <x49aa4qpt5m.fsf@segfault.boston.devel.redhat.com>
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1328889842-23231-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Fri, 10 Feb 2012 17:03:58 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>   Hi Jeff,
>
>   these patches implement generic way of handling O_SYNC AIO DIO. They work
> for all filesystems except for ext4 and xfs. Thus together with your patches,
> all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
> btrfs, and xfs (to check that I didn't break anything when the generic code
> is unused) and things seem to work fine. Will you add these patches to your
> series please? Thanks.

Thanks, Jan!  I'll add them in and give them some testing.  I should be
ready to repost the series early next week.

Cheers,
Jeff
