Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42598 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaAMEoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 23:44:12 -0500
Message-ID: <52D36F19.3070207@sandeen.net>
Date: Sun, 12 Jan 2014 22:44:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Dave Chinner <david@fromorbit.com>
CC: xfs@oss.sgi.com, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: Add pairing mount options test
References: <1389162648-19309-1-git-send-email-quwenruo@cn.fujitsu.com> <52D01CA9.4040107@sandeen.net> <52D33F92.2000609@cn.fujitsu.com> <52D342F0.5020402@sandeen.net> <20140113015239.GD3469@dastard> <52D34EBD.4020508@cn.fujitsu.com> <20140113032650.GH3469@dastard> <52D364DA.4000708@cn.fujitsu.com>
In-Reply-To: <52D364DA.4000708@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/12/14, 10:00 PM, Qu Wenruo wrote:
> Now I'm interested in how other filesystems like xfs makes sure that every pairing
> mount options are tested.

For starters, xfs actually doesn't handle very many options during remount.

Many of them are quite tricky to do, which made me wonder if they all
actually worked properly for btrfs.  :)

-Eric
