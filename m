From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
Date: Wed, 28 Dec 2011 22:36:12 +0200
Message-ID: <4EFB7DBC.8070601@gmail.com>
References: <4EFB6D4F.6070002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EFB6D4F.6070002@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Well now machine2 has just crashed too...
http://pastebin.com/gvfUm0az

On =CE=A4=CE=B5=CF=84=CE=AC=CF=81=CF=84=CE=B7, 28 =CE=94=CE=B5=CE=BA=CE=
=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 9:26:07 =CE=BC=CE=BC, Kons=
tantinos Skarlatos wrote:
> Hello all:
> I have two machines with btrfs, that give me the "blocked for more=20
> than 120 seconds" message. After that I cannot write anything to disk=
,=20
> i am unable to unmount the btrfs filesystem and i can only reboot wit=
h=20
> sysrq-trigger.
>
> It always happens when i write many files with rsync over network.=20
> When i used 3.2rc6 it happened randomly on both machines after=20
> 50-500gb of writes. with rc7 it happens after much less writes,=20
> probably 10gb or so, but only on machine 1 for the time being. machin=
e=20
> 2 has not crashed yet after 200gb of writes and I am still testing th=
at.
>
> machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs=20
> filesystem that lies on a 10TB md raid5. mount options=20
> compress=3Dzlib,compress-force
>
> machine 2: btrfs over md raid 5 (4x2TB)=3D5.5TB filesystem. mount=20
> options compress=3Dzlib,compress-force
>
> pastebins:
>
> machine1:
> 3.2rc7 http://pastebin.com/u583G7jK
> 3.2rc6 http://pastebin.com/L12TDaXa
>
> machine2:
> 3.2rc6 http://pastebin.com/khD0wGXx
> 3.2rc7 (not crashed yet)
