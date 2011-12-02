From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 0/5] fix bugs of sub transid -- WARNING: at fs/btrfs/ctree.c:432
Date: Fri, 2 Dec 2011 17:30:49 +0100
Message-ID: <20111202163049.GO12759@twin.jikos.cz>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com> <20111128151030.GK12759@twin.jikos.cz> <4ED432EB.2070706@cn.fujitsu.com> <20111129161729.GM12759@twin.jikos.cz> <4ED6D923.9010805@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, sensille@gmx.net
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED6D923.9010805@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2011 at 09:32:19AM +0800, Liu Bo wrote:
> The warning is aimed to check whether this ref_cow root is in this transaction, so we can change it
> to WARN_ON(root->ref_cows && trans->transaction->transid > root->last_trans);

Ok, I'll add this change to next testing round.

> BTW, did you catch any "parent transid mismatch" during the test? :)

No such message appeared in the syslog.


david
