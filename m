Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752827AbdICD1Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Sep 2017 23:27:16 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Sun, 3 Sep 2017 03:26:34 +0000
Message-ID: <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
References: <20170830034001.rlwaqsitco65exqi@merlins.org>
 <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
 <20170831173607.GM15290@merlins.org>
 <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
 <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
 <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
 <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>,<20170903010127.eafg2i7ry2tprro7@merlins.org>
In-Reply-To: <20170903010127.eafg2i7ry2tprro7@merlins.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was looking through the code for other ways to cut down memory usage when I noticed we only catch improper re-allocations, not adding another ref for metadata which is what I suspect your problem is.  I added another patch and pushed it out, sorry for the churn.

Josef

Sent from my iPhone

> On Sep 2, 2017, at 9:01 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
>> On Sun, Sep 03, 2017 at 12:30:07AM +0000, Josef Bacik wrote:
>> My bad, I forgot I don't dynamically allocate the stack trace space so my patch did nothing, I blame the children for distracting me.  I've dropped allocating the action altogether for the on disk stuff, that should dramatically reduce the memory usage.  You can just do a git pull since I made a new commit.  You are mounting with -o ref_verify on only the one fs right?  Give this a try and if it still doesn't work we can try a stripped down version that doesn't build the initial tree and just hope that the problem exists in allocating a new block and not modifying the refs for an existing block.  Thanks,
> 
> Good news, this time it booted without crashing on OOM.
> 
> I'll now get to see how it runs and hopefully it won't crash due to
> other problems in 4.13
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
> Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=-zFzT4JPwAa-JY-PU1TRHuerYPlZf00HGKCTgtSRcxU&s=fyD-Ff-h7AsoFbRF2RqvzlURQJg38B1RTu7A_n0OLs8&e=                          | PGP 1024R/763BE901
