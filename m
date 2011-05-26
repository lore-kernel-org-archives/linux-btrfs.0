From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: Backref walking utilities
Date: Thu, 26 May 2011 09:51:25 +0800
Message-ID: <4DDDB21D.6040904@cn.fujitsu.com>
References: <4DDA2EA7.9080305@cn.fujitsu.com> <4DDA30AD.2020409@gmx.net> <4DDD1B7A.4090709@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDD1B7A.4090709@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/25/2011 11:08 PM, Jan Schmidt wrote:
> On 05/23/2011 12:02 PM, Arne Jansen wrote:
>> Hi liubo,
>>
>> On 23.05.2011 11:53, liubo wrote:
>>> As one of my plans, I'm going to take this project over unless someone has been working on it.
>> Jan Schmidt has a patch for scrub nearly ready, that does some
>> ref-walking to report affected files to the user. While this is
>> kernel code and you're planning to add user-space code, it might
>> still be possible to share some of it. Maybe the efforts can be
>> coordinated.
> 
> The patches are ready and should be flexible enough to use for your
> purpose. However I use them in context of the scrub code, thus I'm
> planning to send them out as soon as the current version of scrub is
> included in Chris' master.
> 
> If anybody wants to test the patches before that (apply well against
> Arnes scrub branch), drop me an email.
> 

I'd like to have a look ahead.  Would you please give the address of these patches?

thanks,
liubo

> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

