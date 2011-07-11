From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: btrfs hang in flush-btrfs-5
Date: Mon, 11 Jul 2011 22:21:21 +0100
Message-ID: <ivfpgh$g8r$1@dough.gmane.org>
References: <iv6ntd$3o5$1@dough.gmane.org> <ivenfi$iph$1@dough.gmane.org> <4E1B08FC.6030907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:

> On 07/11/2011 07:40 AM, Jeremy Sanders wrote:
>> Jeremy Sanders wrote:
>> 
>>> Hi - I'm trying btrfs with kernel 2.6.38.8-32.fc15.x86_64 (a Fedora
>>> kernel). I'm just doing a tar-to-tar copy onto the file system with
>>> compress- force=zlib. Here are some traces of the stuck processes.
>> 
>> I've managed to reproduce the hang using the latest btrfs from the
>> repository. I had to remove some of the tracing lines to get it to
>> compile under 2.6.38.8 and an ioctl which wasn't defined. Here is is
>> where it is stuck:
>> 
> 
> Hrm well that is just unlikely and hard to hit.  Will you try this and
> see if it helps you?  Thanks,

It's got quite a bit further past than where it got before and hasn't 
crashed yet. I will let you know when it has finished ok.

I see that the btrfs-delalloc (rather than endio-write) thread is taking up 
100% of CPU and the write speed seems to have dropped during the copying, 
however. The copy started with using endio-write fully on both cores and now 
is using dealloc a lot.

Jeremy


