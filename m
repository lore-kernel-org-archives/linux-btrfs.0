Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751406AbdFZQ7Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 12:59:24 -0400
Subject: Re: [PULL] Btrfs for 4.13, part 1
To: David Sterba <dsterba@suse.com>
References: <cover.1498229425.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <007ac50e-71e2-6e25-7d17-821720a37317@fb.com>
Date: Mon, 26 Jun 2017 12:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1498229425.git.dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/2017 11:16 AM, David Sterba wrote:
> Hi,
>
> this is the main batch for 4.13. There are some user visible changes, see
> below. The core updates improve error handling (mostly related to bios), with
> the usual incremental work on the GFP_NOFS (mis)use removal. All patches have
> been in for-next for an extensive amount of time.
>
> Thre will be followups but I want push the series (111 patches) forward. There
> are also some updates to adjacent subsystems (writeback and blocklayer), so I
> want to give some stable point for merging in the upcoming weeks.

Thanks Dave, I ran this (along with the updates we added) through a long 
stress and the usual xfstests.

For everyone else on the list, since I'm heading off to vacation until 
~July 9th, Dave is sending this off to Linus once the merge window starts.

-chris
