From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 01 Apr 2012 22:42:57 +0300
Message-ID: <4F78AFC1.3000907@gmail.com>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com> <20120401164136.61800@gmx.net> <4F788619.1040403@gmail.com> <20120401170754.238550@gmx.net> <4F788E1C.6080404@gmail.com> <20120401181154.61780@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Norbert Scheibner <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120401181154.61780@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 1/4/2012 9:11 =CE=BC=CE=BC, Norbert Scheibner wrote:
>> On: Sun, 01 Apr 2012 20:19:24 +0300 Konstantinos Skarlatos wrote
>
>>> I use btrfs for my backups. Ones a day I rsync --delete --inplace
>>> the
>> complete system to a subvolume, snapshot it, delete some tempfiles
>> in the snapshot.
>>
>> In my setup I rsync --inplace many servers and workstations, 4-6
>> times a day into a 12TB btrfs volume, each one in its own
>> subvolume. After every backup a new ro snapshot is created.
>>
>> I have many cross-subvolume duplicate files (OS files, programs,
>> many huge media files that are copied locally from the servers to
>> the workstations etc), so a good "dedupe" script could save lots of
>> space, and allow me to keep snapshots for much longer.
>
> So the script should be optimized not to try to deduplicate the whole
> fs everytime but the newly written ones. You could take such a file
> list out of the rsync output or the btrfs subvolume find-new
> command.
>
a cron task with btrfs subvolume find-new would be ideal i think
> Albeit the reflink patch, You could use such a bash-script inside one
> subvolume, after the rsync and before the snapshot. I don't know how
> much space it saves for You in this situation, but it's worth a try
> and a good way to develop such a script, because before You write
> anything to disc You can see how many duplicates are there and how
> much space could be freed.
>
> MfG Norbert

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
