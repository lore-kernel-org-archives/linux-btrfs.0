From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 0/5] fix bugs of sub transid
Date: Mon, 28 Nov 2011 16:10:30 +0100
Message-ID: <20111128151030.GK12759@twin.jikos.cz>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	sensille@gmx.net
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 21, 2011 at 06:10:19PM +0800, Liu Bo wrote:
> We've been sufferring two big bugs with sub transid:
> one is a bug related to root's last_snapshot, the other is a bug related to
> disk extent refs' generation.

Do you have a testcase to trigger and check these bugs?

> 1) The first patch fixes a warning,
> 2) the second one fixes the last_snapshot bug,
> 3) the third one has already been in for-linus branch, but not in "danger"
>    branch, so I add it here for the integrity,
> 4) the fourth one fixes a transid mismatch bug,
> 5) the fifth one fixes the disk extent refs' generation bug.
> 
> Any advices and tests are welcome!

I have rebased this series on top of current cmason/for-linus (24a70313969),
should anybody want to test.

(repo address: http://repo.or.cz/w/linux-2.6/btrfs-unstable.git )


david
