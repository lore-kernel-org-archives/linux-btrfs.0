From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix missing clear_extent_bit
Date: Wed, 28 Sep 2011 08:34:03 -0400
Message-ID: <4E83143B.3050907@redhat.com>
References: <1317204034-11239-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317204034-11239-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2011 06:00 AM, Liu Bo wrote:
> We forget to clear inode's dirty_bytes and EXTENT_DIRTY at the end of write.
> 

We don't set EXTENT_DIRTY unless we failed to read a block and that's to
keep track of the area we are re-reading, unless I'm missing something?
 Thanks,

Josef
