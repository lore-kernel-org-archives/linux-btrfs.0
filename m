Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:57757 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757135AbcJPT5v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 15:57:51 -0400
Subject: Re: speed up cp --reflink=always
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <6e902770-05f3-2562-eeb3-dd9ef53b9406@profihost.ag>
 <4e88008a-b844-e7d6-cba3-f86ce976b753@mendix.com>
 <4205dfd5-46ea-976b-f6b3-6aa5a5eca12f@profihost.ag>
 <d93e8441-dee3-cca3-5e11-27bf813baa1f@mendix.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <93d599d3-c172-b431-2f07-6787db1f7250@profihost.ag>
Date: Sun, 16 Oct 2016 21:57:23 +0200
MIME-Version: 1.0
In-Reply-To: <d93e8441-dee3-cca3-5e11-27bf813baa1f@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 16.10.2016 um 21:48 schrieb Hans van Kranenburg:
> On 10/16/2016 08:54 PM, Stefan Priebe - Profihost AG wrote:
>> Am 16.10.2016 um 00:37 schrieb Hans van Kranenburg:
>>> On 10/15/2016 10:49 PM, Stefan Priebe - Profihost AG wrote:
>>>>
>>>> cp --reflink=always takes sometimes very long. (i.e. 25-35 minutes)
>>>>
>>>> An example:
>>>>
>>>> source file:
>>>> # ls -la vm-279-disk-1.img
>>>> -rw-r--r-- 1 root root 204010946560 Oct 14 12:15 vm-279-disk-1.img
>>>>
>>>> target file after around 10 minutes:
>>>> # ls -la vm-279-disk-1.img.tmp
>>>> -rw-r--r-- 1 root root 65022328832 Oct 15 22:13 vm-279-disk-1.img.tmp
>>>
>>> Two quick thoughts:
>>> 1. How many extents does this img have?
>>
>> filefrag says:
>> 1011508 extents found
> 
> To cp --reflink this, the filesystem needs to create a million new
> EXTENT_DATA objects for the new file, which point all parts of the new
> file to all the little same parts of the old file, and probably also
> needs to update a million EXTENT_DATA objects in the btrees to add a
> second backreference back to the new file.

Thanks for this explanation.

> 
>>> 2. Is this an XY problem? Why not just put the img in a subvolume and
>>> snapshot that?
>>
>> Sorry what's XY problem?
> 
> It means that I suspected that your actual goal is not spending time to
> work on optimizing how cp --reflink works, but that you just want to use
> the quickest way to have a clone of the file.
> 
> An XY problem is when someone has problem X, then thinks about solution
> Y to solve it, then runs into a problem/limitation/whatever when trying
> Y and asks help with that actual problem when doing Y while there might
> in the end be a better solution to get X done.

ah ;-) makes sense.

>> Implementing cp reflink was easier - as the original code was based on
>> XFS. But shouldn't be cp reflink / clone a file be nearly identical to a
>> snapshot? Just creating refs to the extents?
> 
> Snapshotting a subvolume only has to write a cowed copy of the top-level
> information of the subvolume filesystem tree, and leaves the extent tree
> alone. It doesn't have to do 2 million different things. \o/

Thanks for this explanation. Will look into switching to subvolumes.
Wasn't able todo this before as i was always running into ENOSPC issues
which was solved last week.

Greets,
Stefan
