From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Backref walking utilities
Date: Wed, 25 May 2011 17:08:42 +0200
Message-ID: <4DDD1B7A.4090709@jan-o-sch.net>
References: <4DDA2EA7.9080305@cn.fujitsu.com> <4DDA30AD.2020409@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDA30AD.2020409@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2011 12:02 PM, Arne Jansen wrote:
> Hi liubo,
> 
> On 23.05.2011 11:53, liubo wrote:
>> As one of my plans, I'm going to take this project over unless someone has been working on it.
> 
> Jan Schmidt has a patch for scrub nearly ready, that does some
> ref-walking to report affected files to the user. While this is
> kernel code and you're planning to add user-space code, it might
> still be possible to share some of it. Maybe the efforts can be
> coordinated.

The patches are ready and should be flexible enough to use for your
purpose. However I use them in context of the scrub code, thus I'm
planning to send them out as soon as the current version of scrub is
included in Chris' master.

If anybody wants to test the patches before that (apply well against
Arnes scrub branch), drop me an email.

-Jan
