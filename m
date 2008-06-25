From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH] btrfs orphan code
Date: Wed, 25 Jun 2008 16:24:11 -0400
Message-ID: <1214425451.10187.694.camel@think.oraclecorp.com>
References: <20080624180450.GA9813@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080624180450.GA9813@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-06-24 at 14:04 -0400, Josef Bacik wrote:
> Hello,
> 
> I want to throw this out here now that I've got most of the heavy lifting done
> for this code to make sure what I'm doing is ok for now.  I've added an
> ORPHAN_DIR item key to have a hidden dir per root.  Right now it just does it
> for whatever the default root is on mount, but I'm going to fix that to do the
> orphan dir check/creation on lookup of a subvolume root.  I also changed
> btrfs_insert_dir_item to take an index flag to indicate whether or not we want
> to add a DIR_INDEX item along with the dir item.  Let me know if there are any
> glaring design problems with what I've done.  Thanks much,
> 

Ok, I've poked my head out of the locking code now, this is a pretty
good start.  But, the plan you mentioned on irc to use a special item
type instead of a directory is a better way to go.

After that, we'll have to hammer on it a bit to flush out any races
between relinking a recently unlinked file and the orphan code.

Thanks a lot for tackling this.

-chris


