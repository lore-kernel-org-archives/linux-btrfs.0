Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:37648 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeEQPaZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 11:30:25 -0400
Received: by mail-it0-f68.google.com with SMTP id 70-v6so9389707ity.2
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 08:30:25 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
To: Jeff Mahoney <jeffm@suse.com>, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
 <9b32d248-6311-fa20-9d17-364310316412@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0e8be98d-61f4-0c67-f826-8cb5be3b7e47@gmail.com>
Date: Thu, 17 May 2018 11:22:17 -0400
MIME-Version: 1.0
In-Reply-To: <9b32d248-6311-fa20-9d17-364310316412@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-17 10:46, Jeff Mahoney wrote:
> On 5/16/18 6:35 PM, David Sterba wrote:
>> On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
>>> Not yet ready for the integration. As I need to introduce
>>> -o no_read_mirror_policy instead of -o read_mirror_policy=-<devid>
>>
>> Mount option is mostly likely not the right interface for setting such
>> options, as usual.
> 
> 
> I've seen a few alternate suggestions in the thread.  I suppose the real
> question is: what and where is the intended persistence for this choice?
> 
> A mount option gets it via fstab.  How would a user be expected to set
> it consistently via ioctl on each mount?  Properties could work, but
> there's more discussion needed there.  Personally, I like the property
> idea since it could conceivably be used on a per-file basis.

For the specific proposed use case (the tests), it probably doesn't need 
to be persistent beyond mount options.

However, this also allows for a trivial configuration using a slow 
storage device to provide redundancy for a fast storage device of the 
same size, which is potentially very useful for some people.  In that 
case, I can see most people who would be using it wanting it to follow 
the filesystem regardless of what context it's being mounted in (for 
example, it shouldn't need an extra option if mounted from a recovery 
environment or if it's moved to another system).

Most of my reason for recommending properties is that filesystem level 
properties appear to be the best thing BTRFS has to store per-volume 
configuration that's supposed to stay with the volume, despite not 
really being used for that even though there are quite a few mount 
options that are logical candidates for this type of thing (for example, 
the `ssd` options, `metadata_ratio`, and `max_inline` all make more 
logical sense as a property of the volume, not the mount).
