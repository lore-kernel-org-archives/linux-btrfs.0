From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: new integration-danger branch pushed out (kernel)
Date: Tue, 01 Nov 2011 17:22:20 +0800
Message-ID: <4EAFBA4C.1080201@cn.fujitsu.com>
References: <20111101024957.GH4468@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101024957.GH4468@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

On 11/01/2011 10:49 AM, Chris Mason wrote:
> Hi everyone,
> 
> I've pushed out a new integration branch, but it is not for general use.
> 
> I'm still going through and hammering on the new logging code code to
> make sure it is properly backwards compatible with older kernels and
> that it hasn't introduced any new bugs.
> 
> *** Please do not use this code on anything other than test filesystems that
> can easily be reformatted. ***
> 
> In testing the new sub-transid logging code, I've spent a lot of time
> hunting logging bugs, and writing new tests to try and make sure the
> logging code is working correctly in general.  Between that and some new
> tests from Arne, I've had to make some pretty big changes to the code.
> 

I'm giving a hard read on the new code, and I notice a slight change:
@@ -3006,14 +3179,11 @@ out:
 static int inode_in_log(struct btrfs_trans_handle *trans,
                 struct inode *inode)
 {
-       struct btrfs_root *root = BTRFS_I(inode)->root;
        int ret = 0;
 
-       mutex_lock(&root->log_mutex);
-       if (BTRFS_I(inode)->logged_trans == trans->transid &&
-           BTRFS_I(inode)->last_sub_trans <= root->last_log_commit)
+       if (BTRFS_I(inode)->logged_trans >= trans->transaction->transid &&
+           BTRFS_I(inode)->last_trans < BTRFS_I(inode)->logged_trans)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                ret = 1;
-       mutex_unlock(&root->log_mutex);
        return ret;
 }

since we've moved the "sub_transid++" update to btrfs_sync_log(), the ending of log,
say there is a case like this:

transaction ------------------------------------------ start
                 |
    sub_trans A  | --- start
                 |
                 | --- modify inode X, and set X's last_trans to sub_transid
 |               |
 |               | --- fsync inode X, and set X's logged_trans to sub_transid
 |               |
 |               | --- in btrfs_sync_log(), sub_transid++
 |               |
\|/              | --- end
                 |
   sub_trans A+1 | --- start
                 |
                 | --- no change to inode X
                 |
                 | --- fsync inode X
                 |
                 | --- in inode_in_log(), X's last_trans is equal to X's logged_trans,
                       unchanged X is just in the log, but we need to log X again.

    ......             ......

transaction ------------------------------------------ end

we do not want this, does we?  Or am I missing something?

thanks,
liubo

> This meant collapsing Fujitsu's original nicely broken out patches into
> a larger patch so that I could be sure later kernel bisections wouldn't
> run into problems.  All credit to Liu Bo and Fujitsu for getting the
> sub-transid work going, any bugs in the pushed patch are probably ones
> I introduced.
> 
> integration-danger merges in the new sub-transid logging code along with
> all of the fixes Dave Sterba has been tracking, and Josef's code.
> 
> I'm still merging in trees from Arne and Jan Schmidt, those should get
> pushed out tomorrow afternoon.
> 
> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

