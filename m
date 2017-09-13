Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:47873 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdIMM0r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 08:26:47 -0400
Received: by mail-io0-f172.google.com with SMTP id j141so1513647ioj.4
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 05:26:46 -0700 (PDT)
Subject: Re: Storage and snapshots as historical yearly
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
 <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
 <34d8d690-d999-0081-4a80-65a6de439639@petezilla.co.uk>
 <3e3eae9d-f7d0-fafb-6faf-6eecdf724c8b@gmail.com>
 <d81cfebb-6b8d-94cf-2bfd-091b55fb86b8@petezilla.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <943e78f9-8feb-ff5c-46eb-b035a3f0971c@gmail.com>
Date: Wed, 13 Sep 2017 08:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <d81cfebb-6b8d-94cf-2bfd-091b55fb86b8@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-13 07:51, Pete wrote:
> On 09/12/2017 01:16 PM, Austin S. Hemmelgarn wrote:
> 
>>> Diverting away from the original topic, what issues with overlayfs and
>>> btrfs?
>> As mentioned, I thought whiteout support was missing, but if you're
>> using it without issue, I might be wrong.
> 
> Whiteout works fine.  Upper and lower layers and working directory are
> all on btrfs subvolumes.  Snapshotting seems fine.
Hmm, just double checked myself.  Apparently I was operating based on 
old information.
> 
> 
> 
>>> I'm using btrfs to create 'base' operating system containers (btrfs) and
>>> then using overlayfs for a few 'upper' containers for specific
>>> applications, so the upper parts of the overlays contain only the config
>>> and data files and I can apply OS updates only on the lower ones.
>>>
>>> I do note that changes in the 'base' os can take time to propagate to
>>> the upper containers and I'm probably not being sensible in not stopping
>>> the upper containers when updating the lower ones.  This is also does
>>> not seem to be what overlaysfs is intended for.  However, for my light
>>> usage it generally works OK and is useful to me.
>> Actually, this is pretty well in-line with one of the intended use cases
>> (it was mostly designed for efficient multiple instantiation of Docker
>> or LXC containers).  The other big use case is 'live' systems that only
>> retain state while powered on, like most install images.
> 
> OK, I only spotted the latter use case when reading up, apart from one
> website which seemed to mention using it for containers.
Yeah, containers are the other big one.  It's not unusual for someone to 
need to spin up a dozen or more instances of essentially the same 
container (think large build systems), and without an overlay mount, you 
end up multiplying the space for the base image times the number of 
containers.

