From: Harshavardhana <harsha@gluster.com>
Subject: ENOTEMPTY on "rm -rf" for snapshot and subvolume
Date: Wed, 07 Apr 2010 17:44:20 -0700
Message-ID: <4BBD26E4.7070106@gluster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Everyone,

      Recently i created a snapshot of an existing volume which had some 
amount of data.
      Now that after creating the snapshot i have tried deleting the 
same snapshot.  But i am
      getting ENOTEMPTY for "rmdir". But when i see the actual files 
inside are deleted
      not the parent directory.

      From the code it looks like

      if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
             inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
                 return -ENOTEMPTY;

      Why would "unlink" succeeds for the files inside the directory?, 
yet returning ENOTEMPTY

      This looks odd after this, i  went ahead and tried deleting the 
the existing volume itself
      same result.

      So i was wondering if at all this is supposed to work this way, do 
i need to use "btrfs"
      commands to delete subvolumes always? and their relative snapshots?.

      But either in that case too returning ENOTEMPTY does confuse a 
user a lot. Isn't it valid
      just by returning EPERM will explain a lot to users saying that 
this is a snapshot of a
      subvolume or a parent subvolume which is not supposed to be 
deleted this way.

Regards

-- 
Harshavardhana
http://www.gluster.com

