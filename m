Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44067 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752893AbdH2Onx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:43:53 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Tue, 29 Aug 2017 14:43:32 +0000
Message-ID: <8EF72B00-8191-44D9-9297-1796A7FD750E@fb.com>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org>
 <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
 <20170829143955.GD15290@merlins.org>
In-Reply-To: <20170829143955.GD15290@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alright Iâ€™ll figure out a way to differentiate between the fsâ€™s, but being able to scan the fs before itâ€™s mounted was the hardest part so thatâ€™s perfect.  Iâ€™ll get something written up and tested today to make sure it wonâ€™t spit out false positives and send it to you this afternoon or tomorrow.  Thanks,

Josef

On 8/29/17, 10:40 AM, "Marc MERLIN" <marc@merlins.org> wrote:

On Tue, Aug 29, 2017 at 02:30:19PM +0000, Josef Bacik wrote:
> Sorry Marc, Iâ€™ll wire up a bcc script to try and catch when this
> happens.  In order for it to work itâ€™ll need to read the extent tree in
> before you mount the fs, is that something youâ€™ll be able to swing or is
> this your root fs?  Also is it the only btrfs fs on the system?  Thanks,

HI Josef, thanks for your reply.

Thankfully it's not the root FS.
There are 3 btrfs filesystems on that system.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=Rb6fFZaTtI5fFzN4MD03GPvT0eSOYGuRNKKA4pDehzY&s=sMstwHEsJAdwf4N0fDnuUedvuGEPnDiEV-YmTYK8Zxc&e=   


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
