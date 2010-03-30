From: Mark Rada <markrada26@gmail.com>
Subject: Re: Workaround for race condition at boot
Date: Tue, 30 Mar 2010 12:03:01 -0400
Message-ID: <C9E497E0-196F-4FBC-B554-105B4720A667@gmail.com>
References: <9A0AC2A7-90F9-4B80-AF0F-8C65083DE1B5@mailservices.uwaterloo.ca> <20100330130802.GF13190@think>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100330130802.GF13190@think>
List-ID: <linux-btrfs.vger.kernel.org>

Ah, ok, thank you for explaining.

Sent from my iPhone

On 2010-03-30, at 9:08, Chris Mason <chris.mason@oracle.com> wrote:

> On Mon, Mar 29, 2010 at 10:40:12PM -0400, Mark Rada wrote:
>> Hi,
>>
>> In my time playing around with btrfs I have had difficulty in  
>> mounting and btrfs partitions that use multiple devices. I'm aware  
>> that there is a note about a gotcha on the wiki, but I'm not trying  
>> to mount the btrfs partition as the root.
>>
>> However, I have noticed that if I force a btrfs filesystem scan  
>> before trying to mount, then everything will work.
>>
>> I originally created a bug report on the Gentoo Bugzilla:
>> http://bugs.gentoo.org/show_bug.cgi?id=309219
>>
>
> This isn't a race condition, it is built into the filesystem.  Later
> versions of btrfs progs will pull the details right out of udev  
> instead
> of needing btrfsctl -a, but today the btrfsctl -a is the only way.
>
> This is similar to what needs to happen on lvm, its just that the
> initramfs tools already understand lvm ;)
>
> -chris
