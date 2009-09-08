From: Peter Macko <pmacko@eecs.harvard.edu>
Subject: Re: Question about back references
Date: Tue, 08 Sep 2009 17:40:07 -0400
Message-ID: <4AA6CF37.3090206@eecs.harvard.edu>
References: <4AA2C7E6.40200@eecs.harvard.edu> <3d0408630909070241x78f043fdu9bf3f1ddd41a4ddd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630909070241x78f043fdu9bf3f1ddd41a4ddd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks! I have a follow up question: Are back references reference 
counted? If so, this should mean that after the file system COWs an 
inode, it must increase the reference counts of its file extent back 
references. Do we know what is the overhead? In the case they are not 
reference counted, how does the system know when to drop the reference?

What are the bookend extents? Is the number of bookend requests in the 
fourth field of a file extent back reference  the number of times the 
extent occurs within the file?

Thank you,

Peter Macko


Yan, Zheng wrote:
> 2009/9/6 Peter Macko <pmacko@eecs.harvard.edu>:
>   
>> I am trying to understand how exactly the file extent back references work
>> in btrfs. Can please someone tell me if the following is correct? - The back
>> references are accumulated in an in-memory balanced tree (delayed-ref.c and
>> delayed-ref.h) and pushed to disk during the transaction commit (a part of a
>> checkpoint). They are placed into the B-tree under the key (bytenr,
>> BTRFS_EXTENT_REF_KEY, hash of the four fields of the record), so that they
>> are stored next to the file extent forward references.
>>
>>     
> This was correct for btrfs in 2.6.30 and earlier version. We introduced a new
> back references format in 2.6.31. For more information about the new format,
> please read the comments in extent-tree.c
>
>   
>> I am also wondering about the implications of copy on write: Imagine that
>> you have an inode with four file extents and thus also four back references.
>> COW of one of the extents then causes the COW of the inode. The new version
>> of the inode has a different transaction ID, which is also one of the fields
>> of back reference records. This causes the file system to add four new back
>> reference records - one for the modified extent and three for the unmodified
>> ones (since the transaction ID field has to be updated). Does this really
>> happen, or is there some scheme to avoid adding these extra records?
>>
>>     
> It's avoid by using the new back references format.
>
> Yan, Zheng
>   

