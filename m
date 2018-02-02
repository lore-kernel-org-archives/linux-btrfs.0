Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34489 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbeBBMgf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 07:36:35 -0500
Received: by mail-io0-f171.google.com with SMTP id c17so22772601iod.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Feb 2018 04:36:35 -0800 (PST)
Subject: Re: [PATCH 2/2] btrfs: add read_mirror_policy parameter devid
To: Edmund Nadolski <enadolski@suse.de>, Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-3-anand.jain@oracle.com>
 <f4772f0c-c53e-c859-7da9-b2181a3507c1@suse.com>
 <7a21d5f0-b7f0-9da6-22b6-b45976d6ab40@oracle.com>
 <7fdfcf9a-2bc5-7f1b-1417-3ccc95cdcf83@suse.com>
 <27eaef30-69ae-b5a6-2cd6-9035c61615e7@oracle.com>
 <7eb73e78-f6ca-be5f-4505-a88d60172037@suse.com>
 <c0e67c67-324e-938a-b87c-3831c2604676@oracle.com>
 <d87d2cbb-0512-1c26-28c0-4e7733ec35bf@suse.de>
 <fe6055a4-8778-03dd-1ade-692a7a83a946@oracle.com>
 <6b033ae4-ab8f-199d-cc9a-d8bcdd4c4ad4@suse.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d7768bdd-a015-9912-03f5-0e302ac85705@gmail.com>
Date: Fri, 2 Feb 2018 07:36:27 -0500
MIME-Version: 1.0
In-Reply-To: <6b033ae4-ab8f-199d-cc9a-d8bcdd4c4ad4@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-01 18:46, Edmund Nadolski wrote:
> 
> 
> On 02/01/2018 01:12 AM, Anand Jain wrote:
>>
>>
>> On 02/01/2018 01:26 PM, Edmund Nadolski wrote:
>>> On 1/31/18 7:36 AM, Anand Jain wrote:
>>>>
>>>>
>>>> On 01/31/2018 09:42 PM, Nikolay Borisov wrote:
>>>>
>>>>
>>>>>>> So usually this should be functionality handled by the raid/san
>>>>>>> controller I guess, > but given that btrfs is playing the role of a
>>>>>>> controller here at what point are we drawing the line of not
>>>>>>> implementing block-level functionality into the filesystem ?
>>>>>>
>>>>>>     Don't worry this is not invading into the block layer. How
>>>>>>     can you even build this functionality in the block layer ?
>>>>>>     Block layer even won't know that disks are mirrored. RAID
>>>>>>     does or BTRFS in our case.
>>>>>>
>>>>>
>>>>> By block layer I guess I meant the storage driver of a particular raid
>>>>> card. Because what is currently happening is re-implementing
>>>>> functionality that will generally sit in the driver. So my question was
>>>>> more generic and high-level - at what point do we draw the line of
>>>>> implementing feature that are generally implemented in hardware devices
>>>>> (be it their drivers or firmware).
>>>>
>>>>    Not all HW configs use RAID capable HBAs. A server connected to a SATA
>>>>    JBOD using a SATA HBA without MD will relay on BTRFS to provide all
>>>> the
>>>>    features and capabilities that otherwise would have provided by such a
>>>>    presumable HW config.
>>>
>>> That does sort of sound like means implementing some portion of the
>>> HBA features/capabilities in the filesystem.
>>>
>>> To me it seems this this could be workable at the fs level, provided it
>>> deals just with policies and remains hardware-neutral.
>>
>>   Thanks. Ok.
>>
>>> However most
>>> of the use cases appear to involve some hardware-dependent knowledge
>>> or assumptions.
>>
>>> What happens when someone sets this on a virtual disk,
>>> or say a (persistent) memory-backed block device?
>>
>>   Do you have any policy in particular ?
> 
> No, this is your proposal ;^)
> 
> You've said cases #3 thru #6 are illustrative only. However they make
> assumptions about the underlying storage, and/or introduce potential for
> unexpected behaviors. Plus they could end up replicating functionality
> from other layers as Nikolay pointed out. Seems unlikely these would be
> practical to implement.
The I/O one would actually be rather nice to have and wouldn't really be 
duplicating anything (at least, not duplicating anything we consistently 
run on top of).  The pid-based selector works fine for cases where the 
only thing on the disks is a single BTRFS filesystem.  When there's more 
than that, it can very easily result in highly asymmetrical load on the 
disks because it doesn't account for current I/O load when picking a 
copy to read.  Last I checked, both MD and DM-RAID have at least the 
option to use I/O load in determining where to send reads for RAID1 
setups, and they do a far better job than BTRFS at balancing load in 
these cases.
> 
> Case #2 seems concerning if it exposes internal,
> implementation-dependent filesystem data into a de facto user-level
> interface. (Do we ensure the devid is unique, and cannot get changed or
> re-assigned internally to a different device, etc?)
The devid gets assigned when a device is added to a filesystem, it's a 
monotonically increasing number that gets incremented for every new 
device, and never changes for a given device as long as it remains in 
the filesystem (it will change if you remove the device and then re-add 
it).  The only exception to this is that the replace command will assign 
the new device the same devid that the device it is replacing had (which 
I would argue leads to consistent behavior here).  Given that, I think 
it's sufficiently safe to use it for something like this.
