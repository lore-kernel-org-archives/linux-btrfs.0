From: Christian Brunner <christian@brunner-muc.de>
Subject: Re: Ceph on btrfs 3.4rc
Date: Fri, 4 May 2012 22:24:16 +0200
Message-ID: <CAJafhzR3PFKUGq6JutzeaF61X=kJ9x62fH62-BYAs0S=sa=P9A@mail.gmail.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
	<20120424152141.GB3326@localhost.localdomain>
	<Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
	<CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
	<20120503141354.GC1914@localhost.localdomain>
	<f35947dc064c7ff1a073b430a2d681f5@hq.newdream.net>
	<20120503152053.GA7313@localhost.localdomain>
	<1e9c626272411bb1fb403a3aa8aeced7@hq.newdream.net>
	<20120503194924.GC7313@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josh Durgin <josh.durgin@dreamhost.com>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120503194924.GC7313@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

2012/5/3 Josef Bacik <josef@redhat.com>:
> On Thu, May 03, 2012 at 09:38:27AM -0700, Josh Durgin wrote:
>> On Thu, 3 May 2012 11:20:53 -0400, Josef Bacik <josef@redhat.com>
>> wrote:
>> > On Thu, May 03, 2012 at 08:17:43AM -0700, Josh Durgin wrote:
>> >
>> > Yeah all that was in the right place, I rebooted and I magically
>> > stopped getting
>> > that error, but now I'm getting this
>> >
>> > http://fpaste.org/OE92/
>> >
>> > with that ping thing repeating over and over. =A0Thanks,
>>
>> That just looks like the osd isn't running. If you restart the
>> osd with 'debug osd =3D 20' the osd log should tell us what's going =
on.
>
> Ok that part was my fault, Duh I need to redo the tmpfs and mkcephfs =
stuff after
> reboot. =A0But now I'm back to my original problem
>
> http://fpaste.org/PfwO/
>
> I have the osd class dir =3D /usr/lib64/rados-classes thing set and l=
ibcls_rbd is
> in there, so I'm not sure what is wrong. =A0Thanks,

Thats really strange. Do you have the osd logs in /var/log/ceph? If
so, can you look if you find anything about "rbd" or "class" loading
in there?

Another thing you should try is, whether you can access ceph with rados=
:

# rados -p rbd ls
# rados -p rbd -i /proc/cpuinfo put testobj
# rados -p rbd -o - get testobj

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
