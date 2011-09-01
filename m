From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: fix warning in iput for bad-inode
Date: Thu, 1 Sep 2011 04:45:19 +0200
Message-ID: <20110901024519.GB11678@ds.suse.cz>
References: <20110817185619.4660.78543.stgit@localhost6>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	josef@redhat.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817185619.4660.78543.stgit@localhost6>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I saw something different with your patch. After creating and deleting
lots of subvolumes followed by an umount, there is one unpleasant
interaction with orphans.

After first mount attempt, the mount fails with

# mount /dev/sdb5
mount: Stale NFS file handle

syslog:
[  256.050787] btrfs: could not do orphan cleanup -116
[  256.962781] btrfs: open_ctree failed


the -116 is -ESTALE which your patch adds.

Another mount attempt and success, no relevant message in syslog. Reproducible.


btrfs_orphan_cleanup
  btrfs_iget -> fails

2373                 inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
2374                 if (IS_ERR(inode)) {
2375                         ret = PTR_ERR(inode);
2376                         goto out;
2377                 }
...
2440 out:
2441         if (ret)
2442                 printk(KERN_CRIT "btrfs: could not do orphan cleanup %d\n", ret);
2443         btrfs_free_path(path);
2444         return ret;
2445 }


I'm concerned about leaving some unprocessed orphans "somewhere".


david
