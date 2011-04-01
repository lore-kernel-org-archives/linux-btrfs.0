From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Do not use free space caching!
Date: Fri, 01 Apr 2011 16:27:19 +0300
Message-ID: <4D95D2B7.4020202@gmail.com>
References: <4D939E76.1060801@redhat.com> <1301605604.12638.5.camel@ayu> <20110331225956.GC7484@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110331225956.GC7484@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/2011 1:59 =CF=80=CE=BC, Josef Bacik wrote:
> On Thu, Mar 31, 2011 at 05:06:42PM -0400, Calvin Walton wrote:
>> On Wed, 2011-03-30 at 17:19 -0400, Josef Bacik wrote:
>>> Hello,
>>>
>>> Just found a big bug in the free space caching stuff that will resu=
lt in
>>> early ENOSPC.  I'm working on fixing this bug, but it won't be unti=
l
>>> tomorrow that I'll have it completely working, so for now make sure=
 to
>>> mount -o clear_cache so that it just clears the cache and doesn't u=
se it.
>>>
>>> NOTE: It doesn't cause problems other than early ENOSPC, you won't =
get
>>> corruption or anything like that, tho you could possibly panic.
>>>
>>> Sorry for the inconvenience.  Thanks,
>> Any chance you could provide a little more information about which
>> kernels are affected? Is it any kernel with free space cache support=
 (is
>> 2.6.38.x included?) - and if so, do you plan on submitting the fix t=
o
>> the stable kernel series?
>>
> Yeah it affects any kernel that has the free space cache feature, whi=
ch I think
> started in .37.  Course you have to have specifically enabled it, so =
it's not a
> huge problem.  I've submitted a patch, but since it's currently an op=
tional
> feature I don't think it needs to go to stable.  Thanks,
So it will have to wait for 2.6.39? If possible please push it for=20
inclusion it in the next stable of 2.6.38, as 2.6.39 is a few months=20
away and i wont risk an early RC for my system

Thanks
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
