From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 20:19:24 +0300
Message-ID: <4F788E1C.6080404@gmail.com>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com> <20120401164136.61800@gmx.net> <4F788619.1040403@gmail.com> <20120401170754.238550@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Norbert Scheibner <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120401170754.238550@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On =CE=9A=CF=85=CF=81=CE=B9=CE=B1=CE=BA=CE=AE, 1 =CE=91=CF=80=CF=81=CE=AF=
=CE=BB=CE=B9=CE=BF=CF=82 2012 8:07:54 =CE=BC=CE=BC, Norbert Scheibner w=
rote:
>> On: Sun, 01 Apr 2012 19:45:13 +0300 Konstantinos Skarlatos wrote
>
>>> That's my point. This poor man's dedupe would solve my problems her=
e
>> very well. I don't need a zfs-variant of dedupe. I can implement suc=
h a
>> file-based dedupe with userland tools and would be happy.
>>
>> do you have any scripts that can search a btrfs filesystem for dupes
>> and replace them with cp --reflink?
>
> Nothing really working and tested very well. After I get to known the=
 missing cp --reflink feature I stopped to develop the script any furth=
er.
>
> I use btrfs for my backups. Ones a day I rsync --delete --inplace the=
 complete system to a subvolume, snapshot it, delete some tempfiles in =
the snapshot.

In my setup I rsync --inplace many servers and workstations, 4-6 times=20
a day into a 12TB btrfs volume, each one in its own subvolume. After=20
every backup a new ro snapshot is created.

I have many cross-subvolume duplicate files (OS files, programs, many=20
huge media files that are copied locally from the servers to the=20
workstations etc), so a good "dedupe" script could save lots of space,=20
and allow me to keep snapshots for much longer.


> In addition to that I wanted to shrink file-duplicates.
>
> What the script should do:
> 1. I md5sum every file
> 2. If the checksums are identical, I compare the files
> 3. If 2 or more files are really identical:
>     - move one to a temp-dir
>     - cp --reflink the second to the position and name of the first
>     - do a chown --reference, chmod --reference and touch --reference
>       to copy owner, file mode bits and time from the orginal to the
>       reflink-copy and then delete the original in temp-dir
>
> Everything could be done with bash. Thinkable is the use of a databas=
e for the md5sums, which could be used for other purposes in the future=
=2E


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
