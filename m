Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33375 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366AbcBQKEX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 05:04:23 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160217095646.GA21482@infradead.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
	<20160215204614.7977.2848.stgit@birch.djwong.org>
	<20160217095646.GA21482@infradead.org>
Date: Wed, 17 Feb 2016 10:04:23 +0000
Message-ID: <CAL3q7H5NRUXvo=mEtGr4-S4yPT7k_yw6LsMAq_V8bPD1T=7r0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] generic/304: fix high offset
From: Filipe Manana <fdmanana@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 17, 2016 at 9:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Feb 15, 2016 at 12:46:14PM -0800, Darrick J. Wong wrote:
>> "Invalid argument" is a better response to an impossibly high offset
>> dedupe request than "extents don't match", so change the test.
>
> What does btrfs return here?

-EINVAL, so this makes the test pass on btrfs.

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
