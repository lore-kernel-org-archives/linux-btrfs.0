From: Josef Bacik <jbacik@redhat.com>
Subject: Question about e8569813849b5da394a195c7e76b4faa452b12d1
Date: Wed, 8 Oct 2008 16:59:48 -0400
Message-ID: <20081008205947.GA18375@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Is there a reason 

-       if (search_end == (u64)-1)
-               search_end = btrfs_super_total_bytes(&info->super_copy);

happened in the commit from $SUBJECT?  If its just a mistake thats fine I'll add
it back with my current patch, but if there is a reason it needed to go then I
need to know that too so I can figure out a different way to do what I want to
do.  Thanks,

Josef
