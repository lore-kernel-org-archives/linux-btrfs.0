From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Thu, 22 Sep 2011 12:13:44 +0200
Message-ID: <20110922101344.GA13667@kashmir>
References: <20110921185350.GA6618@kashmir>
 <4E7A4695.9080106@redhat.com>
 <20110921231055.GN22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dave@jikos.cz>
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110921231055.GN22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2011 at 01:10:55AM +0200, David Sterba wrote:
> please prefix printk messages with "btrfs: "

Well my computer crashed before I could reboot with the newly compiled
kernel.  And now it bugs while it tries to mount the kernel meaning my
computer is fscked! :-)

Bug at fs/btrfs/free-space-cache.c:1327

(I have a screenshot if needed)

function remove_from_bitmap

        /*
         * XXX - this can go away after a few releases.
         *
         * since the only user of btrfs_remove_free_space is the tree logging
         * stuff, and the only way to test that is under crash conditions, we
         * want to have this debug stuff here just in case somethings not
         * working.  Search the bitmap for the space we are trying to use to
         * make sure its actually there.  If its not there then we need to stop
         * because something has gone wrong.
         */
        search_start = *offset;
        search_bytes = *bytes;
        search_bytes = min(search_bytes, end - search_start + 1);
        ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes);
===>    BUG_ON(ret < 0 || search_start != *offset);

So question is now: how do I recover from this? :-)

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
