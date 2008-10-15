From: Avi Kivity <avi@redhat.com>
Subject: Re: Data-deduplication?
Date: Wed, 15 Oct 2008 19:49:44 +0200
Message-ID: <48F62D38.5060109@redhat.com>
References: <20081012020629.GA14615@bludgeon.org> <878wssswqa.fsf@basil.nowhere.org> <48F5F284.1020309@redhat.com> <20081015141543.GT12131@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081015141543.GT12131@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:

   

>>> There are some patches to do in QEMU's cow format for KVM. That's
>>> user level only.
>>>  
>>>       
>> And thus, doesn't work for sharing between different images, especially 
>> at runtime. 
>>     
>
> It would work if the images are all based once on a reference image, won't it?
>   

Yes and no.  It's difficult to do it at runtime, and it allows one qemu 
to access another guest's data (for read-only).

Also, it's almost impossible to do at runtime.


-- 
error compiling committee.c: too many arguments to function

