From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 17:24:10 +0800
Message-ID: <4E4B88BA.4030603@oracle.com>
References: <4E4B2452.9070407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4B2452.9070407@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>



And a rough implementation design is here below. (As of now this does
not include the GNOME integration since I have no idea how to do that).

Further, implementation will contain 2 new files
/etc/init.d/btrfs and /<path>/btrfs-auto-snapshot,

any idea where does a file like btrfs-auto-snapshot should be placed
(with its purpose as mentioned below).

-------
1.
File: /etc/init.d/btrfs :
      This will contain the global start and stop knob
      (something like `service btrfs start`)

2.
Crontab: Upon start, crontab will be updated with something like the 
following.
    every 15min `<path>/btrfs-auto-snapshot cleanup>`
    every 15min `/<path>/btrfs-auto-snapshot 15min`
    every hr   `/<path>/btrfs-auto-snapshot hr`
    every day  `/<path>/btrfs-auto-snapshot day`
    every month `/<path>/btrfs-auto-snapshot month`
    every year  `/<path>/btrfs-auto-snapshot year`


3.
File: /<path>/btrfs-auto-snapshot :
  to process the call from cronjob.
    - check the config and check the target fs for the snapshot
    - check the space in the target FS
    - call btrfs cli to take snapshot (provide src and destination)
    - check if snapshot cleanup is required

  to process the calls from '/etc/init.d/btrfs'

  configuration setting.
   - to set which btrfs fs will participate in the auto-snapshot
   - to indicate if auto snapshot has to stop when target FS is 80% full

---------


Thanks, Anand



On 08/17/2011 10:15 AM, Anand Jain wrote:
>
> sorry forgot to follow the protocol, now included RFC in the subject.
>
>
> Hi,
>
> Appears that no one is working on the auto-snapshot feature for btrfs,
> so here I am implementing the same.
>
> Below is a draft on the feature list. Any comments / questions /
> suggestions are welcome, please do let me know.
>
> btrfs auto snapshot feature will include:
> Initially:
> - configurable timely snapshots
> - uses services and crontab to schedule
> - Gnome integration
> - snapshot rollback and cleanups
> - snapshot trashing based on available space
> - snapshot destination will be subvol/.btrfs/snapshot@<time> and
> snapshot/.btrfs/snapshot@<time> for subvolume and snapshot
> respectively
>
> Later:
> -integration with (a ?) backup software
> - snapshot trashing per backup confirmation
> - rollback from the backup server
>
> Challenges:
> - rollback per file or dir instead of entire snapshot-rollback ?
> - integrating into the btrfs gui ?
> - some FS (samfs) support continues backup
> - do we need a new role for the snapshot management ? zfs does.
> - we don't need a snapshot if the master file-system didn't change
> at all
> - snapshots are writable by default, hope that sudo-er doesn't
> modify the snapshot - do we need to implement a kind of read-only
> snapshot ?
>
> Thanks, -Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
