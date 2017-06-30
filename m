Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63090 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750931AbdF3O7N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 10:59:13 -0400
Date: Fri, 30 Jun 2017 22:59:05 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
Message-ID: <20170630145905.GC7046@lufq.5F>
References: <20170623040601.akpyyvh3dgry6nn5@merlins.org>
 <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
 <20170623161750.r7utffpsmyl5tcik@merlins.org>
 <20170624023409.GT14690@merlins.org>
 <0d93c1c4-1feb-b589-0c8f-1fced7b77686@cn.fujitsu.com>
 <20170627231146.GA16192@merlins.org>
 <20170628071026.GA21006@lufq.5F>
 <20170628144348.abvqowzmeveyzssn@merlins.org>
 <20170629133615.GA2381@lufq.5F>
 <20170629153035.dlla7iq5tqxzaujf@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20170629153035.dlla7iq5tqxzaujf@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 08:30:35AM -0700, Marc MERLIN wrote:
>On Thu, Jun 29, 2017 at 09:36:15PM +0800, Lu Fengqi wrote:
>> On Wed, Jun 28, 2017 at 07:43:48AM -0700, Marc MERLIN wrote:
>> >[cc trimmed]
>> >
>> >On Wed, Jun 28, 2017 at 03:10:27PM +0800, Lu Fengqi wrote:
>> >> Because the output is abnormal, except for the relevant DIR_ITEM and
>> >> DIR_INDEX, I can't find the above mentiond INODE_ITEM and EXTENT_DATA.
>> >> I wonder if the file system is online when this command is executed? If
>> >> so, please re-execute it offline again; if not, could you apply my
>> >> patches re-check it again?
>> >
>> >The filesystem was offline and I had those 2 patches applied.
>> 
>> I am afraid I don't know why the inode item disappers. Besides, if
>> btrfs-debug-tree can't find the inode item, btrfs check shouldn't report
>> this inode item's extent data interrupt. Could you check the disk
>> again? The error output may have changed.
>
>I just did but it takes 24H. I just have the results now: 
>gargamel:~# btrfs check --mode lowmem  /dev/mapper/dshelf2
>Checking filesystem on /dev/mapper/dshelf2
>UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
>checking extents
>checking free space cache
>cache and super generation don't match, space cache will be invalidated
>checking fs roots
>ERROR: root 3862 EXTENT_DATA[18170706 4096] interrupt
>ERROR: root 3862 EXTENT_DATA[18170706 16384] interrupt
>ERROR: root 3862 EXTENT_DATA[18170706 20480] interrupt
>ERROR: root 3862 EXTENT_DATA[18170706 135168] interrupt
>ERROR: root 3862 EXTENT_DATA[18170706 1048576] interrupt
>ERROR: errors found in fs roots
>found 5544779124736 bytes used, error(s) found
>total csum bytes: 5344523140
>total tree bytes: 71323058176
>total fs tree bytes: 59288403968
>total extent tree bytes: 5378277376
>btree space waste bytes: 10912183048
>file data blocks allocated: 7830914256896
> referenced 6244104495104
>
>
>This is looking better, but not 0.
>Can I ignore these or should we look into them still?
>
>Marc
>-- 
>"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
>Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>
>

Personally, I think since the normal mode didn't report any error
related this inode, then these error maybe caused by the bug of lowmem
mode and btrfs-debug-tree.

At your convenience, would you please give me all items about this
inode? I think it can provide some clues regarding the disappearance
of inode and the extent interrupt. It can be dumped by this following
command:

# btrfs-debug-tree /dev/mapper/dshelf2 | grep -C 10 18170706

Please pay attention that, this dump may contain filenames, feel free
to mask the filenames.

Thank you for your assistance.

-- 
Thanks,
Lu


