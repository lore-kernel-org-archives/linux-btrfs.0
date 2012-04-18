From: David Sterba <dave@jikos.cz>
Subject: Re: Kernel bug in BTRFS (kernel 3.3.0)
Date: Wed, 18 Apr 2012 11:25:42 +0200
Message-ID: <20120418092542.GE20982@twin.jikos.cz>
References: <CAPPqfY0T7KmTx=5tcwbUs-zZcB+-yxf01-CWFWY7LUqxepAuNg@mail.gmail.com>
 <4F8E418A.2020801@oracle.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olivier Doucet <webmaster@ajeux.com>, linux-btrfs@vger.kernel.org
To: anand jain <anand.jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F8E418A.2020801@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2012 at 12:22:34PM +0800, anand jain wrote:
> > [370517.204350] btrfs: 1 errors while writing supers
> > [370517.204376] ------------[ cut here ]------------
> > [370517.204391] kernel BUG at fs/btrfs/disk-io.c:2880!
> 
>   -----------
>       if (total_errors > max_errors) {
>           printk(KERN_ERR "btrfs: %d errors while writing supers\n",
>                  total_errors);
>           /* This shouldn't happen. FUA is masked off if unsupported */
>           BUG();
>       }
>   -----------

This is what versions up to 3.3 do.

> 
>   accessible disk(s) is(are) below the critical number of disk(s),
>   btrfs has limited choice. IMO instead of BUG, we could have a
>   user configurable choice to either panic or fail-pending-IO,
>   dump and force-unmount.

With 3.4-rc the BUG is not there, -EIO is returned and the filesystem
goes readonly. Something like the following output, triggered by
echo 1 > /sys/block/DEV/device/delete

[27712.760344] sd 6:0:0:0: [sdg] Synchronizing SCSI cache
[27712.760448] sd 6:0:0:0: [sdg] Stopping disk
[27712.762771] ata6.00: disabled
[27732.780063] BTRFS error (device sdg1) in btree_writepage_io_failed_hook:3735: IO failure (Error occured while writing out btree at 29442048)
[27732.780072] btrfs is forced readonly
[27732.780081] BTRFS error (device sdg1) in btree_writepage_io_failed_hook:3735: IO failure (Error occured while writing out btree at 29437952)
[27732.780090] BTRFS error (device sdg1) in btree_writepage_io_failed_hook:3735: IO failure (Error occured while writing out btree at 29433856)
[27732.780121] BTRFS error (device sdg1) in btrfs_commit_transaction:1455: IO failure (Error while writing out transaction.)
[27732.780131] BTRFS warning (device sdg1): Skipping commit of aborted transaction.
[27732.780137] delayed_refs has NO entry
[27732.780714] ata6: hard resetting link


david
