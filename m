Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39554 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1437752AbdDZPMi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Apr 2017 11:12:38 -0400
Subject: Re: [PULL] Btrfs, updates for 4.12
To: <fdmanana@gmail.com>, David Sterba <dsterba@suse.com>
References: <cover.1492601450.git.dsterba@suse.com>
 <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <31ded450-a0cd-191b-64a5-024a1158cd3a@fb.com>
Date: Wed, 26 Apr 2017 11:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/26/2017 11:06 AM, Filipe Manana wrote:

> Hi,
>
> Did you actually ran xfstests with those readahead patches to
> preallocate radix tree nodes?
>
> With those 2 patches applied (Chris' for-linus.4,12 branch) this
> breaks things and many btrfs specific tests (at least, since I can't
> get pass them) result in tons of traces like the following in a debug
> kernel:

Huh, I did and these didn't come up.  I'll double check I have 
preemption enabled.

-chris
