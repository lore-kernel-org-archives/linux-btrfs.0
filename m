Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39411 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbbBPImL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 03:42:11 -0500
Message-ID: <54E1AD61.7010007@cn.fujitsu.com>
Date: Mon, 16 Feb 2015 16:42:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Karl-Philipp Richter <richter@richtercloud.de>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check --init-csum-tree removes csums again
References: <54E05DCD.3050508@richtercloud.de> <CAJCQCtSSeSbb9r=f830k=5UjKkw=3huE6H_o3oqNWYg2UFJTwg@mail.gmail.com>
In-Reply-To: <CAJCQCtSSeSbb9r=f830k=5UjKkw=3huE6H_o3oqNWYg2UFJTwg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: btrfs check --init-csum-tree removes csums again
From: Chris Murphy <lists@colorremedies.com>
To: Karl-Philipp Richter <richter@richtercloud.de>
Date: 2015年02月16日 13:59
> On Sun, Feb 15, 2015 at 1:50 AM, Karl-Philipp Richter
> <richter@richtercloud.de> wrote:
>> Hi,
>> After running `btrfs check --init-csum-tree` 3.18.2 and 3.19-rc2 on a
>> btrfs all checksums are gone (thousands of line in the form of `no csum
>> found for inode X start Y` in `/var/log/kern.log`). I know that this
>> behavior (to delete all csums) was a stub in a dev version and remember
>> that it was fixed and that I even fixed a csum tree at one point. Could
>> someone please confirm and maybe even point me to a working version?
> I just tried this on CentOS 7 with kernel-3.19-0 and
> btrfs-progs-3.18.2 (from Fedora 21) and it rebuilt the csums, and took
> a little while to do it, unlike 3.12 which was very fast by just
> removing the csums. So... worksforme. However I used it with --repair,
> not by itself.
>
>
The behavior that deletes all csum tree but not to rebuilt them maybe a 
bug happens when extent tree is also
corrupted or with '--init-extent-tree' in 3.18.2.

And --init-csum-tree should imply --repair, so Chris' result should also 
be OK.

To Karl:
Would you please provide the full output of "btrfs check 
--init-csum-tree" and the kernel log?
IMHO this should help to find the bug in btrfsck.

Thanks,
Qu
