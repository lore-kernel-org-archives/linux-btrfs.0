From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 08 Dec 2011 17:41:38 +0100
Message-ID: <4EE0E8C2.1050202@jan-o-sch.net>
References: <fbe25507-c7b7-4ce2-9836-c99a5a4fd0f0@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Phillip Susi <psusi@cfl.rr.com>, Freddie Cash <fjwcash@gmail.com>,
	linux-btrfs@vger.kernel.org
To: BJ Quinn <bj@placs.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fbe25507-c7b7-4ce2-9836-c99a5a4fd0f0@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 08.12.2011 17:28, BJ Quinn wrote:
>>> At any rate, was someone saying that some work had already started on something like btrfs send? 
> 
>> That's right. 
> 
> Google tells me that someone is you.  :)
> 
> What Google wouldn't tell me though was whether you have something I could test?

Well, it's telling you the right thing :-)

Currently I'm distracted by reliable backref walking, which turned out
to be a prerequisite of btrfs send. Once I have that thing done, direct
work on the send/receive functionality will continue.

As soon as there's something that can be tested, you'll find it on this
list.

-Jan
