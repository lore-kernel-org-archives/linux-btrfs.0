From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Backup Command
Date: Fri, 14 Jan 2011 17:17:34 -0800
Message-ID: <201101141717.34772.CACook@quantum-sci.com>
References: <201101100525.32427.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101100525.32427.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


Apparently my command is no good.  No one ever responded to my question below, so maybe I'm not smart enough to ask the right way.

I can ssh from the backup server to the HTPC, but it crashes with a 'dirty' error:
# rsync --progress --archive --hard-links --links --delete-during --delete-excluded --inplace --numeric-ids -e "ssh -l root" root@hex:///home /media/backups/hex-home
root@hex's password: 
protocol version mismatch -- is your shell clean?
(see the rsync man page for an explanation)
rsync error: protocol incompatibility (code 2) at compat.c(173) [Receiver=3.0.7]

"see the rsync man page for an explanation"?  No idea where, but it's sure not in the first third.  I have the same rsync and ssh on each.


On Mon 10 January 2011 05:25:32 Carl Cook wrote:
> 
> Here is my proposed cron:
> 
> btrfs subvolume snapshot hex:///home /media/backups/snapshots/hex-{DATE}
> 
> rsync --archive --hard-links --delete-during --delete-excluded --inplace --numeric-ids -e ssh --exclude-from=/media/backups/exclude-hex hex:///home /media/backups/hex
> 
> btrfs subvolume snapshot droog:///home /media/backups/snapshots/droog-{DATE}
> 
> rsync --archive --hard-links --delete-during --delete-excluded --inplace --numeric-ids -e ssh --exclude-from=/media/backups/exclude-droog droog:///home /media/backups/droog
> 
> Comments?  Criticisms?
> 
> 
