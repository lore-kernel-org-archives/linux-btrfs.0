From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: "not enough space" with "data raid0"
Date: Wed, 28 Mar 2012 14:38:48 -0400
Message-ID: <4F735AB8.40301@ubuntu.com>
References: <C52pxfli1uB@helmut.hullen.de> <20120317121909.GB3172@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Hugo Mills <hugo@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120317121909.GB3172@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 3/17/2012 8:19 AM, Hugo Mills wrote:
>> Where is the problem, how can I use the full space?
>
>     You can't. btrfs requires RAID-0 to be at least two devices wide
> (otherwise it's not striped at all, which is the point of RAID-0). If
> you want to use the full capacity of both disks and don't care about
> the performance gain from striping, use -d single (which is the
> default). If you do care about the performance gain from striping,
> then you're going to have to lose some usable space.

So currently btrfs's concept of raid0 is "stripe across as many disks as 
possible, with a minimum of 2 disks".  Is there any reason for that 
minimum?  I don't see why it can't allow only one if that's the best it 
can manage.

