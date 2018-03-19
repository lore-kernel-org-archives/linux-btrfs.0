Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755350AbeCSLvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 07:51:04 -0400
Subject: Re: High CPU usage of RT threads...
To: Shyam Prasad N <nspmangalore@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CANT5p=o57C_dxnrfF6C7h=cdVz2iVeWeOcri1xOnHhbxt+Gd=A@mail.gmail.com>
 <0e0d6b97-1dd6-23a7-c4ca-f79fefef23ff@suse.com>
 <CANT5p=oYXh7JhEMhZ4zWCHPsof38=xW3hrnjidnm_=WhpfwzFA@mail.gmail.com>
 <29ed3443-6c02-2e46-5f4e-d3dd80e7e817@suse.com>
 <CANT5p=pD+6L76-fBN1ax=UYsqyFzh+PQcc0mK9C7poZi7vNVRg@mail.gmail.com>
 <3e96b978-a14e-7e48-a327-a73bc3004256@suse.com>
 <CANT5p=riMAVR5p4oNPTw37iSfrdFU2ay+Uj-5XF5=DhW0ED0ow@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <22dcd685-2ffd-8f96-ebf9-1b573fc5470c@suse.com>
Date: Mon, 19 Mar 2018 13:51:02 +0200
MIME-Version: 1.0
In-Reply-To: <CANT5p=riMAVR5p4oNPTw37iSfrdFU2ay+Uj-5XF5=DhW0ED0ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.03.2018 13:48, Shyam Prasad N wrote:
> On Mon, Mar 19, 2018 at 4:37 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>>
>>
>> On 19.03.2018 13:02, Shyam Prasad N wrote:
>>> Hi,
>>>
>>> Attaching the sysrq-trigger output.
>>
>> Has this been obtained while the machine experienced a period of a lot
>> of blocked threads? Because the output shows a machine which is idle?
>>
> Hmm.. No, actually. The threads are still taking up CPU, and not
> responding to signals.

Considering all the data you provided I'm inclined to say you have a
problem of different nature than btrfs. Nothing really points at the
direction of btrfs.

> 
> 
