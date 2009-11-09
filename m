From: Andrew Benton <b3nton@gmail.com>
Subject: Re: chmod errors compiling on btrfs
Date: Mon, 09 Nov 2009 17:30:39 +0000
Message-ID: <4AF851BF.7010304@gmail.com>
References: <4AF5DA58.1060600@gmail.com> <20091109151503.GA2812@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091109151503.GA2812@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/09 15:15, Chris Mason wrote:
> On Sat, Nov 07, 2009 at 08:36:40PM +0000, Andrew Benton wrote:
>>
>> Both times the files created were world writeable when they should
>> have been read only. I get the same errors if I compile as myself or
>> root. If I compile in my home folder (on a reiserfs partition) they
>> compile with no problem. I'm using a self compiled vanila 2.6.31.4
>> kernel. I created the partition with btrfs-progs-0.19.
>
> We fixed some umask problems recently, these should be fixed in the
> master branch of the btrfs-unstable repo (which is against 2.6.31).
>

Thanks, I'll give that a try

Andy

