From: David Sterba <dave@jikos.cz>
Subject: Re: Segfault on "btrfs subvolume delete" with kernel 3.3.4
Date: Mon, 30 Apr 2012 18:07:35 +0200
Message-ID: <20120430160735.GA6740@twin.jikos.cz>
References: <4F9E7B2E.2030109@daevel.fr>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, josef@redhat.com
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F9E7B2E.2030109@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2012 at 01:44:46PM +0200, Olivier Bonvalet wrote:
> Apr 30 13:37:05 frozen kernel: [  238.508458] RIP: e030:[<ffffffffa004207f>]
> [<ffffffffa004207f>] btrfs_unlink_subvol+0x184/0x1f9 [btrfs]
> Apr 30 13:37:05 frozen kernel: [  238.508496] RAX: 00000000ffffffe4 RBX:
> ffff880268af81b0 RCX: ffff880272180e58

the same crash has been reported

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16239

and the call to BUG_ON has been replaced by a transaction abort within
the error handling series in 3.4-rc*

The error code is -28 ie ENOSPC, and if I'm guessing the crash site

  btrfs_unlink_subvol+0x184/0x1f9 

correctly, it's the last call to update_inode that fails:

3.4-rc:
3091         btrfs_i_size_write(dir, dir->i_size - name_len * 2);
3092         dir->i_mtime = dir->i_ctime = CURRENT_TIME;
3093         ret = btrfs_update_inode(trans, root, dir);

[3.3:        BUG_ON(ret)]

3094         if (ret)
3095                 btrfs_abort_transaction(trans, root, ret);
3096 out:
3097         btrfs_free_path(path);
3098         return ret;
3099 }

Josef, seems the global reserve was not enough, and it looks similar to
the situation where ENOSPC is returned during truncating a file 0 on a
full fs (ie. the recommend get-away step from a full fs).

> And now I have a "frozen" (= status D) process "btrfs-transacti" (for a
> different subvolume).
> 
> Is there something to do to fix that ?

In your case only reboot. As stated above, 3.4 should handle this more
gracefully.


david
