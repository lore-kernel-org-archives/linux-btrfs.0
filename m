Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33246 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdFNNyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 09:54:54 -0400
Subject: Re: [PATCH] btrfs: test for device flush-able should be after wait
 code
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1497434558-715-1-git-send-email-anand.jain@oracle.com>
 <20170614122637.GA25451@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6f0a0979-3411-5fff-f241-f5cd2060b4b6@oracle.com>
Date: Wed, 14 Jun 2017 22:01:05 +0800
MIME-Version: 1.0
In-Reply-To: <20170614122637.GA25451@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/14/2017 08:26 PM, David Sterba wrote:
> On Wed, Jun 14, 2017 at 06:02:38PM +0800, Anand Jain wrote:
>> write_dev_flush() checks if the device is flush capable, however as
>> the device mode can change any time, this check should be after the
>> wait part of the code.
> 
> This would apply to code before "btrfs: wait part of the
> write_dev_flush() can be separated out", right?

  Yes.

> The problematic case is when a flush bio is sent, queue status changes
> and waiting is skipped. A bio would leak. Next time the flushing is
> enabled, write_dev_flush allocaes a new bio and either it would leak or
> waiting will happen as expected.
> 
> The bio would leak only if the barriers are switched between write and
> wait. Not impossible, but I still think a race hard to win. The
> consequences are not absolutely fatal.

  Yeah more of a theoretical problem and hard to reproduce unless there
  is a deliberate attempt.

> Also, the cleanups in write_dev_flush fix the bug in another way, so we
> don't need this separate patch as a potential stable backport. The patch
> mentioned above can be considered a fix but would need some manual
> adaptations to apply. Therefore I don't think we need the $subj patch.

  Agreed. Kindly ignore this and the V2.2 of
     [PATCH 3/3 v2.2] btrfs: wait part of the write_dev_flush()...
  patch as well.

Thanks, Anand
