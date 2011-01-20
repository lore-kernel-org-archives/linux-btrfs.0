From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Adding a disk fails
Date: Thu, 20 Jan 2011 14:31:36 -0800
Message-ID: <201101201431.36716.CACook@quantum-sci.com>
References: <201101201318.40686.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101201318.40686.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


I must have done something wrong because for the past week or so, almost none of my questions have been answered here.  I'm pretty much in trouble now because I have -no- backups, as I cannot get my backup server running, as I've put all my eggs in the btrfs basket.  Am I asking things wrong, or am I supposed to be asking somewhere else?


On Thu 20 January 2011 13:18:40 Carl Cook wrote:
> 
> Well I've just tried to add a disk to another, but it fails.  I created the first (starting with no traditional partitions) with:
> # mkfs.btrfs /dev/sdb
> 
> Then I mounted it to /media/backups and put lots of files on it.  I shut down the system, added another disk.  Set it up with:
> # mkfs.btrfs /dev/sdc
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> fs created label (null) on /dev/sdc
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 1.82TB
> Btrfs Btrfs v0.19
> # btrfs device scan
> Scanning for Btrfs filesystems
> #
> (... Nothing?  Not even my known mounted sdb drive?)
> # btrfs device add /dev/sdc /media/backups
> ERROR: error adding the device '/dev/sdc'
> 
> It gives no clue as to what might possibly be the problem.  I want raid0.
> 
> Also I can not understand this:
> "Note: While subvolumes can be created anywhere in the filesystem tree, in order to be mounted by name a subvolume or snapshot must be in the root of the btrfs filesystem."
> 
> I want to do this, but do not know what this means.  Tentatively I've created a BTRFS volume and mounted it on /media/backups.  I then created subvolumes as backup-hex, backup-droog, snaps-hex and snaps-droog.  When I created a snapshot it created a subdir under snaps-hex called hex-root.
> 
> It won't allow me to remove snapshots. (Debian Testing)
> 
> Also does anyone know how to create a shapshot with the current date in the name?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
