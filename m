Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753242AbcHWMQ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 08:16:57 -0400
Date: Tue, 23 Aug 2016 08:14:38 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs fixes for 4.8, part 2
Message-ID: <20160823121437.GA74907@clm-mbp>
References: <cover.1471443105.git.dsterba@suse.com>
 <20160823110237.GI16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <20160823110237.GI16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2016 at 01:02:37PM +0200, David Sterba wrote:
>On Wed, Aug 17, 2016 at 05:11:13PM +0200, David Sterba wrote:
>> Hi,
>>
>> this is a short series, mostly small fixes that did not make it to the first
>> round. Please pull, thanks.
>
>As you did not pick this pull request, I'll prepare another one with
>more patches, based on this branch.

Thanks Dave, I've been trying to nail down this fsync memory corruption 
problem.  But, I'll send a pull on Thursday/Friday with or without an 
fsync patch.

-chris
