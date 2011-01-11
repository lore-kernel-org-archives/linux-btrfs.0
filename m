From: =?UTF-8?B?SXZhbiBMYWLDoXRo?= <ilabath@gmail.com>
Subject: Re: Backup Command
Date: Tue, 11 Jan 2011 15:53:44 +0100
Message-ID: <4D2C6EF8.40007@gmail.com>
References: <201101100525.32427.CACook@quantum-sci.com> <201101111519.11246.hka@qbs.com.pl> <4D2C6A42.9080400@gmail.com> <201101111540.27811.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101111540.27811.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/11/11 15:40, Hubert Kario wrote:
> On Tuesday, January 11, 2011 15:33:38 Ivan Lab=C3=A1th wrote:
>> On 01/11/11 15:19, Hubert Kario wrote:
>>> On Tuesday, January 11, 2011 14:54:38 Ivan Lab=C3=A1th wrote:
>>>> On 01/10/11 14:36, Hubert Kario wrote:
>>>>> On Monday 10 of January 2011 14:25:32 Carl Cook wrote:
>>>>>> Here is my proposed cron:
>>>>>>
>>>>>> btrfs subvolume snapshot hex:///home
>>>>>> /media/backups/snapshots/hex-{DATE}
>>>>>>
>>>>>> rsync --archive --hard-links --delete-during --delete-excluded
>>>>>> --inplace --numeric-ids -e ssh
>>>>>> --exclude-from=3D/media/backups/exclude-hex hex:///home
>>>>>> /media/backups/hex
>>>>>>
>>>>>> btrfs subvolume snapshot droog:///home
>>>>>> /media/backups/snapshots/droog-{DATE}
>>>>>>
>>>>>> rsync --archive --hard-links --delete-during --delete-excluded
>>>>>> --inplace --numeric-ids -e ssh
>>>>>> --exclude-from=3D/media/backups/exclude-droog droog:///home
>>>>>> /media/backups/droog
>>>>>>
>>>>>> Comments?  Criticisms?
>>>>>
>>>>> This will make the dates associated with snapshots offset by how =
often
>>>>> cron is run.
>>>>>
>>>>> In other words, if you run above script daily you will have data =
from
>>>>> 2011.01.01 in the hex-2011.01.02 directory.
>>>>>
>>>>> I do save the current date, do a LVM snapshot on the source, rsyn=
c
>>>>> --inplace data over and do a local snapshot naming the folder usi=
ng the
>>>>> saved date. This way the date in the name of backup directory is =
exact
>>>>> to about a second.
>>>>
>>>> If you are mounting a LVM snapshot of an already mounted filesyste=
m,
>>>> would you be willing verify that it is really a snapshot that is
>>>> mounted?
>>>>
>>>> e.g. touch /mnt/live/its_alive && ls /mnt/snapshot/
>>>>
>>>> I am nearly willing to bet it is not a snapshot.
>>>
>>> well, by "LVM snapshot on the source" I meant:
>>> 1. do lvcreate --snapshot
>>> 2. mount newly created volume
>>> 3. use the new directory as the base for rsync
>>> 4. arrange umount and destruction of the snapshot after rsync compl=
etes
>>> (no matter if it was successful)
>>>
>>> and this will in fact not make the "its_alive" visible in /mnt/snap=
shot
>>>
>>> You have to use this procedure if you use LVM snapshots for backup =
no
>>> matter to where do you copy data. That's why I shortened it to a si=
ngle
>>> point -- it's not the part that is important from btrfs perspective=
=2E
>>>
>>> Regards.
>>
>> The point I was trying to make is: it does not work with btrfs.
>> Try the above with a btrfs and you will be surprised.
>> If the source volume uses another filesystem, it should work properl=
y.
>>
>> regards,
>> ivan
>=20
> Yes, you are right, but I don't see a point in using LVM snapshots wi=
th btrfs,=20
> after all the ability to snapshot it on fs level is one of its defini=
ng=20
> features...
>=20

Yes, silently mounting another filesystem is the right thing to do.
When there already is a mounted filesystem probably containing nearly
identical data, the kernel should not bother allocating separate struct=
ures
for yet another copy of it. The user probably won't notice anyway.

--
ivan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
