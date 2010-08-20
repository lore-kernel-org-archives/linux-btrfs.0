From: Jan Kara <jack@suse.cz>
Subject: Usefulness of max_transid in the tree search?
Date: Fri, 20 Aug 2010 23:45:31 +0200
Message-ID: <20100820214531.GA13960@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  Hi,

  I just had a look at how btrfs ioctl searches the tree for new items and
while looking at the code I've noticed that maximum transaction id as
specified in the search is rather useless.
  If I understand right, transaction id is stored in a header of each node.
Thus when any item of the node gets modified, new transaction id gets
recorded. So when you give the search some maximum transaction id, you will
not receive items in nodes where some item has been modified in a later
transaction. That seems like a rather useless set of items to me... Or am I
missing something?

								Honza
