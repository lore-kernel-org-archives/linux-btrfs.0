From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2271!
Date: Fri, 27 May 2011 16:18:33 -0400
Message-ID: <4DE00719.9020002@redhat.com>
References: <383ECFA9-9E51-4CCD-BE24-21FD30813217@gmx.net> <4DC0170C.8000906@redhat.com> <63FD432D-9173-40E4-9A82-711C8C625B0E@gmx.net> <4DDAB207.6060500@redhat.com> <8E5549B7-EBD9-4D7C-87FA-4C49D1C453F8@gmx.net> <4DDD57B5.4070309@redhat.com> <D6012E08-3AC7-4C9A-88DE-42BBDFA40CCB@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Marco Neubauer <icetea1@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <D6012E08-3AC7-4C9A-88DE-42BBDFA40CCB@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/27/2011 03:23 PM, Marco Neubauer wrote:
> 
> Am 25.05.2011 um 21:25 schrieb Josef Back:
>>
>> Hrm well that's doubly weird, the root should be right so it should be
>> able to find the orphan item to delete it for the bad inode, and why the
>> hell are we looping on that orphan item?  Remove the previous patch I
>> gave you and apply this one instead and run with this please and provide
>> me the log.  Sorry in advance, it will likely give you a giant log file
>> again.  Thanks,
> 
> The system didn't crash until now and all I got in the log was the following output.
> This is the expected correct behavior?
> 

Well I was expecting a panic message and such, but if you didn't get any
of that I'm stumped.  I guess this means you've gotten past the mount
section and are able to run for a while before it blows up?  Thanks,

Josef
