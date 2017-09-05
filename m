Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbdIESTv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 14:19:51 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Tue, 5 Sep 2017 18:19:25 +0000
Message-ID: <D509EEE0-1430-40C2-8AD4-117729CFADDD@fb.com>
References: <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
 <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
 <20170903010127.eafg2i7ry2tprro7@merlins.org>
 <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
 <20170903143142.7thdjvkmkdekrzc5@merlins.org>
 <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>
 <20170903144237.svgnaclwmcfdfikt@merlins.org>
 <AD68E364-AF7F-49AA-8376-49E0C7C92998@fb.com>
 <20170903202036.b7j6fcknfiisrnsl@merlins.org>
In-Reply-To: <20170903202036.b7j6fcknfiisrnsl@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alright I just reworked the build tree ref stuff and tested it to make sure it wasnâ€™t going to give false positives again.  Apparently I had only ever used this with very basic existing fsâ€™es and nothing super complicated, so it was just broken for anything complex.  Iâ€™ve pushed it to my tree, you can just pull and build and try again.  This time the stack traces will even work!  Thanks,

Josef

On 9/3/17, 4:21 PM, "Marc MERLIN" <marc@merlins.org> wrote:

On Sun, Sep 03, 2017 at 05:33:33PM +0000, Josef Bacik wrote:
> Alright pushed, sorry about that.
 
I'm reasonably sure I'm running the new code, but still got this:
[ 2104.336513] Dropping a ref for a root that doesn't have a ref on the block
[ 2104.358226] Dumping block entry [115253923840 155648], num_refs 1, metadata 0, from disk 1
[ 2104.384037]   Ref root 0, parent 3414272884736, owner 262813, offset 0, num_refs 18446744073709551615
[ 2104.412766]   Ref root 418, parent 0, owner 262813, offset 0, num_refs 1
[ 2104.433888]   Root entry 418, num_refs 1
[ 2104.446648]   Root entry 69869, num_refs 0
[ 2104.459904]   Ref action 2, root 69869, ref_root 0, parent 3414272884736, owner 262813, offset 0, num_refs 18446744073709551615
[ 2104.496244]   No Stacktrace

Now, in the background I had a monthly md check of the underlying device
(mdadm raid 5), and got some of those. Obviously that's not good, and 
I'm assuming that md raid5 may not have a checksum on blocks, so it won't know
which drive has the corrupted data.
Does that sound right?

Now, the good news is that btrfs on top does have checksums, so running a scrub should
hopefully find those corrupted blocks if they happen to be in use by the filesystem
(maybe they are free).
But as a reminder, this whole thread started with my FS maybe not being in a good state, but both
check --repair and scrub returning clean. Maybe I'll use the opportunity to re-run a check --repair
and a scrub after that to see what state things are in.

md6: mismatch sector in range 3581539536-3581539544
md6: mismatch sector in range 3581539544-3581539552
md6: mismatch sector in range 3581539552-3581539560
md6: mismatch sector in range 3581539560-3581539568  
md6: mismatch sector in range 3581543792-3581543800
md6: mismatch sector in range 3581543800-3581543808
md6: mismatch sector in range 3581543808-3581543816
md6: mismatch sector in range 3581543816-3581543824
md6: mismatch sector in range 3581544112-3581544120
md6: mismatch sector in range 3581544120-3581544128

As for your patch, no idea why it's not giving me a stacktrace, sorry :-/

Git log of my tree does show:
commit aa162d2908bd7452805ea812b7550232b0b6ed53
Author: Josef Bacik <jbacik@fb.com>
Date:   Sun Sep 3 13:32:17 2017 -0400

    Btrfs: use be->metadata just in case
    
    I suspect we're not getting the owner in some cases, so we want to just
    use the known value.
    
    Signed-off-by: Josef Bacik <jbacik@fb.com>

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=BaH33jtavN-1wWyV3yseE5v7ImIAaTXLnjChSr4HnQw&s=3JczS4Mo254uip2aIsYiC_EUHsmGYcCJUUMl6si8NQ8&e=                          | PGP 1024R/763BE901


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
