Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:37966 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754307AbcJPSyI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 14:54:08 -0400
Subject: Re: speed up cp --reflink=always
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
 <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <4205dfd5-46ea-976b-f6b3-6aa5a5eca12f@profihost.ag>
Date: Sun, 16 Oct 2016 20:54:03 +0200
MIME-Version: 1.0
In-Reply-To: <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 16.10.2016 um 00:37 schrieb Hans van Kranenburg:
> Hi,
> 
> On 10/15/2016 10:49 PM, Stefan Priebe - Profihost AG wrote:
>>
>> cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)
>>
>> An example:
>>
>> source file:
>> # ls -la vm-279-disk-1.img
>> -rw-r--r-- 1 root root 204010946560 Oct 14 12:15 vm-279-disk-1.img
>>
>> target file after around 10 minutes:
>> # ls -la vm-279-disk-1.img.tmp
>> -rw-r--r-- 1 root root 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp
> 
> Two quick thoughts:
> 1. How many extents does this img have?

filefrag says:
1011508 extents found

> 2. Is this an XY problem? Why not just put the img in a subvolume and
> snapshot that?

Sorry what's XY problem?

Implementing cp reflink was easier - as the original code was based on
XFS. But shouldn't be cp reflink / clone a file be nearly identical to a
snapshot? Just creating refs to the extents?

Greets,
Stefan
