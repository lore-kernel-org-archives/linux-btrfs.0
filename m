From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix return value check of	btrfs_start_transaction()
Date: Fri, 21 Jan 2011 08:47:12 +0900
Message-ID: <4D38C980.3020001@jp.fujitsu.com>
References: <201101200619.AA00004@T-ITOH1.jp.fujitsu.com> <20110120160959.GB6609@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110120160959.GB6609@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/01/21 1:09), Josef Bacik wrote:
> I'd rather we go through and have these things return an error than d=
o a
> BUG_ON().  We're moving towards a more stable BTRFS, not one that pan=
ics more
> often :).

Yes, I also think so.
This patch is my first step.

My modification policy is as follows:

1. short term
 - To more stable BTRFS, the part that should be corrected is clarified=
=2E=20
 - The panic is not done by the NULL pointer reference etc.

2. long term
=E3=80=80- BUG_ON() is decreased by using the forced-readonly framework=
(already posted by Liu Bo),
    etc.=20

Thanks,
Itoh

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
