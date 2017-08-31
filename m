Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52456 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751821AbdHaRsl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 13:48:41 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Thu, 31 Aug 2017 17:48:23 +0000
Message-ID: <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org>
 <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
 <20170829143955.GD15290@merlins.org>
 <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
 <20170830034001.rlwaqsitco65exqi@merlins.org>
 <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
 <20170831173607.GM15290@merlins.org>
In-Reply-To: <20170831173607.GM15290@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are using 4.11 in production at fb with backports from recent (a month ago?) stuff.  Iâ€™m relatively certain nothing bad will happen, and this branch has the most recent fsync() corruption fix (which exists in your kernel so itâ€™s not new).  That said if you are uncomfortable I can rebase this patch onto whatever base you want and push out a branch, itâ€™s your choice.  Keep in mind this is going to hold a lot of shit in memory, so I hope you have enough, and Iâ€™d definitely remove the sleepâ€™s from your script, thereâ€™s no telling if this is a race condition or not and the overhead of the ref-verify stuff may cause it to be less likely to happen.  Thanks,

Josef 

On 8/31/17, 1:36 PM, "Marc MERLIN" <marc@merlins.org> wrote:

On Thu, Aug 31, 2017 at 02:52:56PM +0000, Josef Bacik wrote:
> Hello,
> 
> Sorry I really thought I could accomplish this with BPF, but ref tracking is just too complicated to work properly with BPF.  I forward ported my ref verification patch to the latest kernel, you can find it in the btrfs-readdir branch of my btrfs-next tree here
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

Thanks.

Now, I have to ask: how safe is this kernel btrfs-wise? I'm ok if it
crashes, but much less so if it damages my filesysetem.
I spent over a week recovering from the last corruption that happened when I
moved to 4.11 (and retreated back to 4.9).

>From other reports you've seen, has 4.11/4.12 been stable enough for others,
and is 4.13-rc (which your branch is based on, correct?) safe enough in your
opinion?
(and yes, just asking for your opinion, I totally understand that you can't
predict all bugs, and you can't give me a 100% assurance)

I do have a backup, but it indeed takes days to recover, and over a week if
the kernel also damages the other FS on that system, which is smaller, but
has maybe 100x the amount of files.

For now, the problem in the subject line, happens rarely-ish (2-3 weeks?)
although if I remove sleeps in my snapshot creation and rotation, it may
start happening more often again.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=dPglHkF4tnOYz0Vu1uAapAEiUpHQoQoBDXggxgitjhY&s=nlFmiXkCAu4Dlg2YpjTNdKNFgTA7NzdZJ3oTOPko2U0&e=   


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
