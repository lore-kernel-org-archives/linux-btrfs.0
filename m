From: Daniel Lee <longinus00@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 11:52:26 -0800
Message-ID: <4F4A8D7A.5070605@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org> <4F4A8A13.2070305@gmail.com> <jie2b6$nla$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jie2b6$nla$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2012 11:48 AM, Brian J. Murrell wrote:
> On 12-02-26 02:37 PM, Daniel Lee wrote:
>> 3.22GB + (896MB * 2) = 5GB
>>
>> There's no mystery here, you're simply out of space.
> Except the mystery that I had to expand the filesystem to something
> between 20GB and 50GB in order to complete the operation, after which I
> could reduce it back down to 5GB.
>
> Cheers,
> b.
>
What's mysterious about that? When you shrink it btrfs is going to throw 
away unused data to cram it all in the requested space and you had empty 
space that was taken up by the metadata allocation. Did you compare 
btrfs fi df after you shrank it with before?
