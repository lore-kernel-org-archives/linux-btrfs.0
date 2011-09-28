From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix missing clear_extent_bit
Date: Wed, 28 Sep 2011 09:44:34 -0400
Message-ID: <1317216807-sup-5328@shiny>
References: <1317204034-11239-1-git-send-email-liubo2009@cn.fujitsu.com> <4E83143B.3050907@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: Liu Bo <liubo2009@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E83143B.3050907@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-09-28 08:34:03 -0400:
> On 09/28/2011 06:00 AM, Liu Bo wrote:
> > We forget to clear inode's dirty_bytes and EXTENT_DIRTY at the end of write.
> > 
> 
> We don't set EXTENT_DIRTY unless we failed to read a block and that's to
> keep track of the area we are re-reading, unless I'm missing something?
>  Thanks,

Josef and I have been talking about this one on IRC.
We do set EXTENT_DIRTY during set_extent_delalloc, but as far as I can
tell we no longer need to.  Can you please experiment with just not
setting the dirty bit during delalloc instead?

-chris
