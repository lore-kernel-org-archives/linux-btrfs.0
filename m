From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Various Questions
Date: Fri, 7 Jan 2011 10:55:43 -0800
Message-ID: <201101071055.44187.CACook@quantum-sci.com>
References: <201101070915.20468.CACook@quantum-sci.com> <AANLkTinCSW-JpwYPYNNAaxHnvXqAy02fMr=Hd34CGxh3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinCSW-JpwYPYNNAaxHnvXqAy02fMr=Hd34CGxh3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


Wow, this rsync and backup system is pretty amazing.  I've always just tarred each directory manually, but now find I can RELIABLY automate backups, and have SOLID versioning to boot.  Thanks to everyone who advised, especially Freddie and Anthony.

I am still waiting for hardware for my backup server, but have been preparing.  On the backup server I'll be doing pull backups for everything except my phone (which is connected intermittently).  I'm going to set up a cron script on the backup server to pull backups once a week (as opposed to once/mo which I've done for 12 years).  I am at a loss how to to lock the database on the HTPC while exporting the dump, as per Lloyd Standish, but will study it.  (Freddie gave a nice script, but it doesn't seem to lock/flush first)  Also don't know how to email results/success/fail on completion, as I've not a very good coder.

But here is my proposed cron:
btrfs subvolume snapshot hex:///home /media/backups/snapshots/hex-{DATE}
rsync --archive --hard-links --delete-during --delete-excluded --inplace --numeric-ids -e ssh --exclude-from=/media/backups/exclude-hex hex:///home /media/backups/hex
btrfs subvolume snapshot droog:///home /media/backups/snapshots/droog-{DATE}
rsync --archive --hard-links --delete-during --delete-excluded --inplace --numeric-ids -e ssh --exclude-from=/media/backups/exclude-droog droog:///home /media/backups/droog

My root filesystems are ext4, so I guess they cannot be snapshotted before backup.  My home directories are/will be BTRFS though.


On Fri 07 January 2011 08:14:17 Hubert Kario wrote:
>> I'd suggest at least 
>> mkfs.btrfs -m raid1 -d raid0 /dev/sdc /dev/sdd
>> if you really want raid0
>
> I don't fully understand -m or -d.  Why would this make a truer raid0 that with no options?

I am beginning to suspect that this is the -default- behavior, as described in the wiki:
"# Create a filesystem across four drives (metadata mirrored, data striped)"

Should I turn off the writeback cache on each drive when running BTRFS?

