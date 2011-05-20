From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: BUG_ON is deleted from the caller of
 btrfs_truncate_item & btrfs_extend_item
Date: Fri, 20 May 2011 12:53:45 +0200
Message-ID: <20110520105345.GV12709@twin.jikos.cz>
References: <201105190519.AA00021@T-ITOH1.jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105190519.AA00021@T-ITOH1.jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, May 19, 2011 at 02:19:08PM +0900, Tsutomu Itoh wrote:
> Currently, btrfs_truncate_item and btrfs_extend_item returns only 0.
> So, the check by BUG_ON in the caller is unnecessary.

well, I don't think it's right to remove the BUG_ONs right now.
btrfs_extend_item has it's own BUG_ON()s, which will hopefully get
turned to sane error handling someday. Currently the bugons are not
executed and do no harm. When btrfs_extend_item does return nonzero
values, that's IMO the right time to remove BUG_ONs in callers and do
error recovery.

I do not like to see that many BUG_ONs, but it's better than unchecked
return values when the function name suggests that things may not go
smooth and error-less.


david
