From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Fri, 13 May 2011 14:52:22 -0400
Message-ID: <4DCD7DE6.3000106@redhat.com>
References: <201105051954.48405.whirm@gmx.com> <4DC2F30D.3080308@redhat.com> <201105131919.37230.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: whirm@gmx.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105131919.37230.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2011 01:19 PM, whirm@gmx.com wrote:
> On Thursday 05 May 2011 20:57:17 Josef Bacik wrote:
> [..]
>> It doesn't look like that bit had my debugging output.  Thanks,
>>
>> Josef
>
> Looks like the last message I sent didn't make to the list. Here's the link to
> the debug log:
>

So unfortunately I don't know how we ended up with duplicate entries in 
the free space cache, but I can make it so we discard the cache if this 
happens.  Please try the patch I just sent to the list

[PATCH] Btrfs: check for duplicate entries in the free space cache

this will make your fs able to be mounted at the very least.  I'll try 
and figure out how this sort of thing happens.  If you manage to make it 
happen on purpose let me know how you did it so I can figure out what 
I'm doing wrong.  Thanks,

Josef
