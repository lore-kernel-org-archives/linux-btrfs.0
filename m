From: Christian Brunner <chb@muc.de>
Subject: Re: BUG at fs/btrfs/inode.c:1587
Date: Wed, 16 Nov 2011 16:26:28 +0100
Message-ID: <CAO47_-99B6uSf8SGU+_ejntfvaKNq4AAX8Ve8kfFVhv-bUN4ww@mail.gmail.com>
References: <CAO47_--H0+6bu4qQ2QA9gZcHvGVWO4QUGCAb3+9a5Kg3+23UiQ@mail.gmail.com>
	<20111116141603.GO29279@shiny>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Christian Brunner <chb@muc.de>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111116141603.GO29279@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/11/16 Chris Mason <chris.mason@oracle.com>:
> On Tue, Nov 15, 2011 at 09:19:53AM +0100, Christian Brunner wrote:
>> Hi,
>>
>> this time I've hit a new bug. This happened while ceph was rebuildin=
g
>> his filestore (heavy io).
>>
>> The btrfs version is from 3.2-rc1, applied to a 3.0 kernel.
>
> This one means some part of the kernel has set a btrfs data page dirt=
y
> without going through the proper setup. =A0A few of us have hit it, b=
ut we
> haven't been able to nail down a solid way to reproduce it.
>
> Have you hit it more than once?


I' sorry, I've only hit this once and it's not reproduceable.

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
