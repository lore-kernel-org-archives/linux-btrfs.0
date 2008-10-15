From: Avi Kivity <avi@redhat.com>
Subject: Re: Data-deduplication?
Date: Wed, 15 Oct 2008 15:39:16 +0200
Message-ID: <48F5F284.1020309@redhat.com>
References: <20081012020629.GA14615@bludgeon.org> <878wssswqa.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <878wssswqa.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
> Ray Van Dolson <rayvd@bludgeon.org> writes:
>
>   
>> I recall their being a thread here a number of months back regarding
>> data-deduplication support for bttfs.
>>
>> Did anyone end up picking that up and giving a go at it?  Block level
>> data dedup would be *awesome* in a Linux filesystem.  It does wonders
>> for storing virtual machines w/ NetApp and WAFL, and even ZFS doesn't
>> have this feature yet (although I've read discussions on them looking
>> to add it).
>>     
>
> There are some patches to do in QEMU's cow format for KVM. That's
> user level only.
>   

And thus, doesn't work for sharing between different images, especially 
at runtime. I'd really, really [any number of reallies], really like to 
see btrfs deduplication.

-- 
error compiling committee.c: too many arguments to function

