Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48256 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761338AbcIOLag (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 07:30:36 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Chris Murphy <lists@colorremedies.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <CAJCQCtT_MDDmy4OGT7SY=TfOhvgSVT1TMVmCKwL8dHcasLnDHw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <6d9d3733-c5b3-86af-bb64-59b83116cfca@oracle.com>
Date: Thu, 15 Sep 2016 19:32:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT_MDDmy4OGT7SY=TfOhvgSVT1TMVmCKwL8dHcasLnDHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the comments. Pls see inline below..

On 09/15/2016 01:38 PM, Chris Murphy wrote:
> On Tue, Sep 13, 2016 at 7:39 AM, Anand Jain <anand.jain@oracle.com> wrote:
>>
>> This patchset adds btrfs encryption support.
>>
>> The main objective of this series is to have bugs fixed and stability.
>> I have verified with fstests to confirm that there is no regression.
>>
>> A design write-up is coming next, however here below is the quick example
>> on the cli usage. Please try out, let me know if I have missed something.
>
> What's the behavior with nested subvolumes having different keys?
>
> subvolume A (encrypted with key A)
>     |
>     - subvolume B (encrypted with key B)
>
> Without encryption I can discover either A or B whether top-level, A,
> or B are mounted.
>
> With encryption, must A be opened [1] for B to be discovered? Must A
> be opened before B can be opened? Or is the subvolume metadata always
> non-encrypted, and it's just file extents that are encrypted? Are
> filenames in those subvolumes discoverable (e.g. btrfs-debug-tree,
> btrfs-image) if the subvolume is not opened? And reflink handling
> between subvolumes behaves how?

   nested encrypting subvolume isn't supported, its just that it wasn't
   in my mind or the use case analysis review which I did, didn't tell
   me that. However I did a bit of code changes, its not that tough to
   get that in the current setup though. Yes only extent encrypted.

Thanks, Anand

>
> [1] open in the cryptsetup open/luksOpen sense
>
>
