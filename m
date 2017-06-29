Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33540 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752933AbdF2NgY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 09:36:24 -0400
Date: Thu, 29 Jun 2017 21:36:15 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
Message-ID: <20170629133615.GA2381@lufq.5F>
References: <20170622025330.GX5303@merlins.org>
 <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com>
 <20170623040601.akpyyvh3dgry6nn5@merlins.org>
 <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
 <20170623161750.r7utffpsmyl5tcik@merlins.org>
 <20170624023409.GT14690@merlins.org>
 <0d93c1c4-1feb-b589-0c8f-1fced7b77686@cn.fujitsu.com>
 <20170627231146.GA16192@merlins.org>
 <20170628071026.GA21006@lufq.5F>
 <20170628144348.abvqowzmeveyzssn@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20170628144348.abvqowzmeveyzssn@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 07:43:48AM -0700, Marc MERLIN wrote:
>[cc trimmed]
>
>On Wed, Jun 28, 2017 at 03:10:27PM +0800, Lu Fengqi wrote:
>> Because the output is abnormal, except for the relevant DIR_ITEM and
>> DIR_INDEX, I can't find the above mentiond INODE_ITEM and EXTENT_DATA.
>> I wonder if the file system is online when this command is executed? If
>> so, please re-execute it offline again; if not, could you apply my
>> patches re-check it again?
>
>The filesystem was offline and I had those 2 patches applied.

I am afraid I don't know why the inode item disappers. Besides, if
btrfs-debug-tree can't find the inode item, btrfs check shouldn't report
this inode item's extent data interrupt. Could you check the disk
again? The error output may have changed.

>
>Marc
>-- 
>"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
>Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901


-- 
Thanks,
Lu


