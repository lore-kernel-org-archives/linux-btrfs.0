From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Balance taking a lot longer than before
Date: Fri, 19 Mar 2010 11:19:33 +0800
Message-ID: <3d0408631003182019i1509d363j98f94661679ea30b@mail.gmail.com>
References: <77201DCC-CC67-4B00-8FFE-AAB17A5D18DA@mailservices.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Mark Rada <marada@uwaterloo.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <77201DCC-CC67-4B00-8FFE-AAB17A5D18DA@mailservices.uwaterloo.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 19, 2010 at 9:44 AM, Mark Rada <marada@uwaterloo.ca> wrote:
> Hi devs,
>
> I've been using btrfs on my file server since 2.6.32 and after upgrading to .33 I noticed that rebalancing took way longer than before.
>
> I have a 5 disk array used for a btrfs md setup, different hard drive sizes, brands, and interfaces.
>
> The last time I rebalanced I was using about 800GB of space on the 4.6TB array, and I started before I went to sleep and it was done when I woke up.
>
> I'm in the middle of a rebalance right now, currently using 950GB, and it has been a full day and the rebalancing is not done yet. Is this an expected change? Is there any way to tell how much longer it will take? Do you need to know more info about the setup?
>

I guess it enters infinite loops. you can check it by checking if
there are a lots of
repeats messages in the kernel log.  If it is true, you can try
deleting some large
files in that FS.
