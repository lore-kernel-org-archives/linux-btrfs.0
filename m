Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58348 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753099AbdICRdy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Sep 2017 13:33:54 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Sun, 3 Sep 2017 17:33:33 +0000
Message-ID: <AD68E364-AF7F-49AA-8376-49E0C7C92998@fb.com>
References: <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
 <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
 <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
 <20170903010127.eafg2i7ry2tprro7@merlins.org>
 <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
 <20170903143142.7thdjvkmkdekrzc5@merlins.org>
 <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>,<20170903144237.svgnaclwmcfdfikt@merlins.org>
In-Reply-To: <20170903144237.svgnaclwmcfdfikt@merlins.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alright pushed, sorry about that.

Josef

Sent from my iPhone

> On Sep 3, 2017, at 10:42 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
>> On Sun, Sep 03, 2017 at 02:38:57PM +0000, Josef Bacik wrote:
>> Oh yeah you need CONFIG_STACKTRACE turned on, otherwise this is going to be difficult ;).  Thanks,
> 
> Right, except that I thought I did:
> 
> saruman:/usr/src/linux-btrfs/btrfs-next# grep STACKTRACE .config
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_RELIABLE_STACKTRACE=y
> CONFIG_STACKTRACE=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
> Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=6hYQEzNFsUwvT2CxYV_u4CrE2zAroYdvDkhnSNUI_aY&s=8wh8ci2P8k3BgZ3s_Fxsh3cZak4P3ESZslRm2vobnqs&e=                          | PGP 1024R/763BE901
