From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Thu, 22 Sep 2011 17:16:33 +0200
Message-ID: <20110922151633.GA16391@kashmir>
References: <20110921185350.GA6618@kashmir>
 <4E7A4695.9080106@redhat.com>
 <20110921231055.GN22205@twin.jikos.cz>
 <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com>
 <4E7B423C.2080007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7B423C.2080007@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2011 at 10:12:12AM -0400, Josef Bacik wrote:
> Well that is from the tree logging code, so give this a whirl.  It's
> going to dump a lot of info so make sure you capture everything before
> the --- cut here --- line.  Thanks,

The patch doesn't apply cleanly to the latest git (since my laptop
doesn't boot anymore, I'm using a different host to compile this) but it
was simple enough to patch manually.  Right now I'm on v3.1-rc7-d93dc5c.

I'm compiling at the moment, so bear with me! :-)

My patch looks like this:
--- fs/btrfs/free-space-cache.c.orig	2011-09-22 11:51:46.442129324 +0200
+++ fs/btrfs/free-space-cache.c	2011-09-22 17:11:46.715162968 +0200
@@ -381,6 +381,8 @@ int __load_free_space_cache(struct btrfs
 			}
 
 			if (entry->type == BTRFS_FREE_SPACE_EXTENT) {
+				printk(KERN_ERR "adding extent [%llu-%llu]\n",
+					e->offset, e->bytes);
 				spin_lock(&ctl->tree_lock);
 				ret = link_free_space(ctl, e);
 				spin_unlock(&ctl->tree_lock);
@@ -402,6 +404,8 @@ int __load_free_space_cache(struct btrfs
 					page_cache_release(page);
 					goto free_cache;
 				}
+				printk(KERN_ERR "adding bitmap [%llu-%llu]\n",
+					e->offset, e->bytes);
 				spin_lock(&ctl->tree_lock);
 				ret = link_free_space(ctl, e);
 				ctl->total_bitmaps++;

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
