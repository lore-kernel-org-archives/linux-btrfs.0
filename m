From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 22:27:38 +0300
Message-ID: <4F78AC2A.8050408@gmail.com>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com> <20120401164136.61800@gmx.net> <4F788619.1040403@gmail.com> <20120401170754.238550@gmx.net> <4F788EE2.4010105@univie.ac.at> <20120401183912.61760@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: "Klaus A. Kreil" <klaus.kreil@univie.ac.at>,
	linux-btrfs@vger.kernel.org
To: Norbert Scheibner <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120401183912.61760@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/2012 9:39 =CE=BC=CE=BC, Norbert Scheibner wrote:
>> On: Sun, 01 Apr 2012 19:22:42 +0200"Klaus A. Kreil" wrote
>
>> I am just an interested reader on the btrfs list and so far have nev=
er
>> posted or sent a message to the list, but I do have a dedup bash scr=
ipt
>> that searches for duplicates underneath a directory (provided as an
>> argument) and hard links identical files.
>>
>> It works very well for an ext3 filesystem, but I guess the basics sh=
ould
>> be the same for a btrfs filesystem.
Thanks for the nice script, it works fine here!
I just added a du -sh "$1" line at the beginning and end to see how muc=
h=20
space it saves.
>
> Everyone feel free to correct me here, but:
> At the moment there is a little problem with the maximum number of ha=
rd links in a directory. So I wouldn't use them wherever possible to av=
oid any thinkable problems in the near future.
>
> Plus to hard link 2 files means, that change one file You change the =
other one. It's something You either don't want to happen or something,=
 which could be done in better ways. The cp --reflink method on a COW-f=
s is a much smarter method.
thats true, cp --reflink is much better. Also am I wrong that btrfs has=
=20
a limitation on the number of hard links that can only be fixed with a=20
disk format change?
>
> Plus hard links across subvolumes do match the case of hard links acr=
oss devices on a traditional fs, which is forbidden.
>
> Plus hard links In my opinion should really be substituted by soft li=
nks, because hard links are not transparent at the first sight and can =
not be copied as it.
>
> So no, I'd rather want the patch to allow cross-subvolume cp --reflin=
k in the kernel and I will wait for that to happen.
>
> Greetings
>     Norbert

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
