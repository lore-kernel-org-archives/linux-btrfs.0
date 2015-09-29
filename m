Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934590AbbI2Kdl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 06:33:41 -0400
Date: Tue, 29 Sep 2015 18:33:38 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
Message-ID: <20150929103338.GI30949@dhcp-13-216.nay.redhat.com>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150929095549.GH30949@dhcp-13-216.nay.redhat.com>
 <560A64EB.5070401@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560A64EB.5070401@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2015 at 06:16:11PM +0800, Qu Wenruo wrote:
>
<snip>
> >>+
> >>+if [ "x$orig_extent_nr" != "x$new_extent_nr" ]; then
> >>+	echo "number of extents mis-match after bull fallocate"
> >
> >print out the $orig_extent_nr and $new_extent_nr in this failure case? I
> >think it's useful to see the difference just from the output diff, don't
> >have to check the full file.
> 
> The problem is, we can't ensure orig/new_extent_nr always be a constant
> value(1 for btrfs case).

Sorry, I might be unclear, I mean print the extent number in the error
path, e.g.

echo "number of extents mis-match after null fallocate"
echo "old: $orig_extent_nr, new: $new_extent_nr"

not matching the number with golden output.

Thanks,
Eryu
