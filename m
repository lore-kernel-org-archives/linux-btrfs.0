Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36154 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdHaLWW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:22:22 -0400
Received: by mail-io0-f175.google.com with SMTP id f99so12814295ioi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 04:22:21 -0700 (PDT)
Subject: Re: mount time for big filesystems
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        linux-btrfs@vger.kernel.org
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <7fbe45ea-9991-8e81-831f-10c9526b2a01@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c2d51a94-048f-13cd-401a-f531450ceccf@gmail.com>
Date: Thu, 31 Aug 2017 07:22:18 -0400
MIME-Version: 1.0
In-Reply-To: <7fbe45ea-9991-8e81-831f-10c9526b2a01@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 07:00, Hans van Kranenburg wrote:
> On 08/31/2017 12:43 PM, Marco Lorenzo Crociani wrote:
>> Hi,
>> this 37T filesystem took some times to mount. It has 47
>> subvolumes/snapshots and is mounted with
>> noatime,compress=zlib,space_cache. Is it normal, due to its size?
> 
> Yes, unfortunately it is. It depends on the size of the metadata extent
> tree. During mount, the BLOCK_GROUP_ITEM objects are loaded from that
> tree. They're scattered all around, causing a lot of random reads when
> your disk cache is still ice cold.
FWIW, you can (sometimes) improve things by running a full balance.

Other than that, there's not much that can be done unless BTRFS gets 
changed to actively group certain data close to each other on disk 
(which would be nice for other reasons too TBH).

