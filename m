From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 19:45:13 +0300
Message-ID: <4F788619.1040403@gmail.com>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com> <20120401164136.61800@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Norbert Scheibner <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120401164136.61800@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On =CE=9A=CF=85=CF=81=CE=B9=CE=B1=CE=BA=CE=AE, 1 =CE=91=CF=80=CF=81=CE=AF=
=CE=BB=CE=B9=CE=BF=CF=82 2012 7:41:36 =CE=BC=CE=BC, Norbert Scheibner w=
rote:
>> On: Sun, 01 Apr 2012 18:30:13 +0300 Konstantinos Skarlatos wrote
>
>> +1 from me too, i would save enormous amounts of space with a patch
>> like that, at least until dedupe is implemented. We could call it "p=
oor
>> man's dedupe"
>
> That's my point. This poor man's dedupe would solve my problems here =
very well. I don't need a zfs-variant of dedupe. I can implement such a=
 file-based dedupe with userland tools and would be happy.

do you have any scripts that can search a btrfs filesystem for dupes=20
and replace them with cp --reflink?

>
> It's there, it's tested, it doesn't break another thing. Use it!
>
> Greetings
>     Norbert
>


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
