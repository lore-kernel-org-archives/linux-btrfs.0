Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:11718 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726570AbeIMNi5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:38:57 -0400
Date: Thu, 13 Sep 2018 16:30:28 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: calibrate extent_end when found a gap
Message-ID: <20180913083027.GC2790@fnst.localdomain>
References: <20180904124201.3287-1-lufq.fnst@cn.fujitsu.com>
 <20180911144120.GA2154@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180911144120.GA2154@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2018 at 04:41:21PM +0200, David Sterba wrote:
>On Tue, Sep 04, 2018 at 08:42:01PM +0800, Lu Fengqi wrote:
>> The extent_end will be used to check whether there is gap between this
>> extent and next extent. If it is not calibrated, check_file_extent will
>
>Do you mean 'synchronized' or 'matching'.

I apologize for this incomprehensible commit message, and I have updated
the commit message.

[PATCH] btrfs-progs: lowmem: fix false alert about the existence of gaps in the check_file_extent

>
>> mistake that there are gaps between the remaining extents.
>
>If this is a bugfix, do you have a testcase? Thanks.
>

The testcase requires some check repair's fixes (including originl and lowmem)
that my colleagues are working on. After they get it, I will send the
testcase.

The attached is the image which can trigger the false alert.

Without the patch mentioned before, lowmem check will false alert that expect
the hole extent [257 EXTENT_DATA 8192].

ERROR: root 5 EXTENT_DATA[257 12288] gap exists, expected: EXTENT_DATA[257 8192]

-- 
Thanks,
Lu
