From: =?UTF-8?B?SXZhbiBMYWLDoXRo?= <ilabath@gmail.com>
Subject: Re: Backup Command
Date: Tue, 11 Jan 2011 14:54:38 +0100
Message-ID: <4D2C611E.7020004@gmail.com>
References: <201101100525.32427.CACook@quantum-sci.com> <201101101436.24713.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101101436.24713.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/10/11 14:36, Hubert Kario wrote:
> On Monday 10 of January 2011 14:25:32 Carl Cook wrote:
>> Here is my proposed cron:
>>
>> btrfs subvolume snapshot hex:///home /media/backups/snapshots/hex-{DATE}
>>
>> rsync --archive --hard-links --delete-during --delete-excluded --inplace
>> --numeric-ids -e ssh --exclude-from=/media/backups/exclude-hex hex:///home
>> /media/backups/hex
>>
>> btrfs subvolume snapshot droog:///home
>> /media/backups/snapshots/droog-{DATE}
>>
>> rsync --archive --hard-links --delete-during --delete-excluded --inplace
>> --numeric-ids -e ssh --exclude-from=/media/backups/exclude-droog
>> droog:///home /media/backups/droog
>>
>> Comments?  Criticisms?
> 
> This will make the dates associated with snapshots offset by how often cron is 
> run.
> 
> In other words, if you run above script daily you will have data from 
> 2011.01.01 in the hex-2011.01.02 directory.
> 
> I do save the current date, do a LVM snapshot on the source, rsync --inplace 
> data over and do a local snapshot naming the folder using the saved date. This 
> way the date in the name of backup directory is exact to about a second.

If you are mounting a LVM snapshot of an already mounted filesystem,
would you be willing verify that it is really a snapshot that is mounted?

e.g. touch /mnt/live/its_alive && ls /mnt/snapshot/

I am nearly willing to bet it is not a snapshot.

--
ivan
