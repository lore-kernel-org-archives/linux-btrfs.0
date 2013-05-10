Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39348 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3EJO0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 10:26:20 -0400
Message-ID: <518D0398.5000706@giantdisaster.de>
Date: Fri, 10 May 2013 16:26:32 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: image: handle superblocks correctly on fs
 with big blocks
References: <1367874680-9502-1-git-send-email-dsterba@suse.cz> <5188BED5.3040201@giantdisaster.de> <20130510112000.GJ16456@twin.jikos.cz>
In-Reply-To: <20130510112000.GJ16456@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/10/2013 13:20, David Sterba wrote:
> On Tue, May 07, 2013 at 10:44:05AM +0200, Stefan Behrens wrote:
>> On Mon,  6 May 2013 23:11:20 +0200, David Sterba wrote:
>>> Superblock is always 4k, but metadata blocks may be larger. We have to
>>> use the appropriate block size when doing checksums, otherwise they're
>>> wrong.
>>>
>>> Signed-off-by: David Sterba <dsterba@suse.cz>
>>> ---
>>>   btrfs-image.c | 27 +++++++++++++++++++++++----
>>>   1 file changed, 23 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/btrfs-image.c b/btrfs-image.c
>>> index 188291c..dca7a28 100644
>>> --- a/btrfs-image.c
>>> +++ b/btrfs-image.c
>>> @@ -469,6 +469,16 @@ static int read_data_extent(struct metadump_struct *md,
>>>   	return 0;
>>>   }
>>>
>>> +static int is_sb_offset(u64 offset) {
>>> +	switch (offset) {
>>> +		case 65536:
>>> +		case 67108864:
>>> +		case 274877906944:
>>
>> Using btrfs_sb_offset() and an if statement would produce the same code
>> and would be more readable.
>
> It was there originally, but this function is called for each block and
> I've optimized it a bit right away. I'll add a comment.

You have not optimized it. gcc does not generate a jump table with 274 
billion entries (I have verified it). The code is the same in both cases.

Here is the C code diff:

*** sw.c        2013-05-10 16:14:48.692299000 +0200
--- if.c        2013-05-10 16:15:03.496639000 +0200
***************
*** 471,482 ****

   static int is_sb_offset(u64 offset)
   {
!       switch (offset) {
!       case 65536:
!       case 67108864:
!       case 274877906944:
                 return 1;
-       }
         return 0;
   }

--- 471,480 ----

   static int is_sb_offset(u64 offset)
   {
!       if (offset == btrfs_sb_offset(0) ||
!           offset == btrfs_sb_offset(1) ||
!           offset == btrfs_sb_offset(2))
                 return 1;
         return 0;
   }


And this is the generated amd64 assembler code diff:

*** /tmp/sw     2013-05-10 15:57:49.096976480 +0200
--- /tmp/if     2013-05-10 16:00:41.712927262 +0200
***************
*** 1378,1397 ****
!     16c1:     49 81 fe 00 00 00 04    cmp    $0x4000000,%r14
       16c8:     74 20                   je     16ea <flush_pending+0x305>
!     16ca:     48 b8 00 00 00 00 40    mov    $0x4000000000,%rax
!     16d1:     00 00 00
!     16d4:     49 39 c6                cmp    %rax,%r14
!     16d7:     74 11                   je     16ea <flush_pending+0x305>
!     16d9:     8b 54 24 4c             mov    0x4c(%rsp),%edx
!     16dd:     89 54 24 20             mov    %edx,0x20(%rsp)
!     16e1:     49 81 fe 00 00 01 00    cmp    $0x10000,%r14
       16e8:     75 08                   jne    16f2 <flush_pending+0x30d>
!     16ea:     c7 44 24 20 00 10 00    movl   $0x1000,0x20(%rsp)
       16f1:     00
       16f2:     b9 00 00 00 00          mov    $0x0,%ecx
!     16f7:     8b 54 24 20             mov    0x20(%rsp),%edx
--- 1378,1397 ----
!     16c1:     49 81 fe 00 00 01 00    cmp    $0x10000,%r14
       16c8:     74 20                   je     16ea <flush_pending+0x305>
!     16ca:     49 81 fe 00 00 00 04    cmp    $0x4000000,%r14
!     16d1:     74 17                   je     16ea <flush_pending+0x305>
!     16d3:     8b 44 24 4c             mov    0x4c(%rsp),%eax
!     16d7:     89 44 24 10             mov    %eax,0x10(%rsp)
!     16db:     48 ba 00 00 00 00 40    mov    $0x4000000000,%rdx
!     16e2:     00 00 00
!     16e5:     49 39 d6                cmp    %rdx,%r14
       16e8:     75 08                   jne    16f2 <flush_pending+0x30d>
!     16ea:     c7 44 24 10 00 10 00    movl   $0x1000,0x10(%rsp)
       16f1:     00
       16f2:     b9 00 00 00 00          mov    $0x0,%ecx
!     16f7:     8b 54 24 10             mov    0x10(%rsp),%edx

