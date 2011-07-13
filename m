From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs hang in flush-btrfs-5
Date: Wed, 13 Jul 2011 10:55:06 -0400
Message-ID: <4E1DB1CA.1050307@redhat.com>
References: <iv6ntd$3o5$1@dough.gmane.org> <ivenfi$iph$1@dough.gmane.org> <4E1B08FC.6030907@redhat.com> <ivfpgh$g8r$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ivfpgh$g8r$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/11/2011 05:21 PM, Jeremy Sanders wrote:
> Josef Bacik wrote:
> 
>> On 07/11/2011 07:40 AM, Jeremy Sanders wrote:
>>> Jeremy Sanders wrote:
>>>
>>>> Hi - I'm trying btrfs with kernel 2.6.38.8-32.fc15.x86_64 (a Fedora
>>>> kernel). I'm just doing a tar-to-tar copy onto the file system with
>>>> compress- force=zlib. Here are some traces of the stuck processes.
>>>
>>> I've managed to reproduce the hang using the latest btrfs from the
>>> repository. I had to remove some of the tracing lines to get it to
>>> compile under 2.6.38.8 and an ioctl which wasn't defined. Here is is
>>> where it is stuck:
>>>
>>
>> Hrm well that is just unlikely and hard to hit.  Will you try this and
>> see if it helps you?  Thanks,
> 
> It's got quite a bit further past than where it got before and hasn't 
> crashed yet. I will let you know when it has finished ok.
> 
> I see that the btrfs-delalloc (rather than endio-write) thread is taking up 
> 100% of CPU and the write speed seems to have dropped during the copying, 
> however. The copy started with using endio-write fully on both cores and now 
> is using dealloc a lot.
> 


When you see that can you get sysrq+w or sysrq+t to get a stacktrace of
what it's doing so I can see if it's something that can be fixed.  Thanks,

Josef
