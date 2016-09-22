Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gum.cmpxchg.org ([85.214.110.215]:55622 "EHLO gum.cmpxchg.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757204AbcIVTsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 15:48:38 -0400
Date: Thu, 22 Sep 2016 15:48:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, jack@suse.com, viro@zeniv.linux.org.uk,
        dchinner@redhat.com, hch@lst.de, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] writeback: allow for dirty metadata accounting
Message-ID: <20160922194829.GB6054@cmpxchg.org>
References: <1474405068-27841-1-git-send-email-jbacik@fb.com>
 <1474405068-27841-3-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474405068-27841-3-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

as we talked off line, I think the idea of maintaining a byte counter
and rounding in balance_dirty_pages() is the best way to do this. And
Jan spotted all the actual bugs, so I only have a few nitpicks :)

On Tue, Sep 20, 2016 at 04:57:46PM -0400, Josef Bacik wrote:
> @@ -44,12 +44,13 @@ void show_mem(unsigned int filter)
>  {
>  	struct zone *zone;
>  
> -	pr_err("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu pagecache:%lu swap:%lu\n",
> +	pr_err("Active:%lu inactive:%lu dirty:%lu metadata_dirty:%lu writeback:%lu unstable:%lu free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu pagecache:%lu swap:%lu\n",
>  	       (global_node_page_state(NR_ACTIVE_ANON) +
>  		global_node_page_state(NR_ACTIVE_FILE)),
>  	       (global_node_page_state(NR_INACTIVE_ANON) +
>  		global_node_page_state(NR_INACTIVE_FILE)),
>  	       global_node_page_state(NR_FILE_DIRTY),
> +	       global_node_page_state(NR_METADATA_DIRTY),
>  	       global_node_page_state(NR_WRITEBACK),

Print NR_METADATA_WRITEBACK here as well?

> @@ -51,6 +51,8 @@ static DEVICE_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
>  static DEVICE_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
>  
>  #define K(x) ((x) << (PAGE_SHIFT - 10))
> +#define BtoK(x) ((x) >> 10)
> +
>  static ssize_t node_read_meminfo(struct device *dev,
>  			struct device_attribute *attr, char *buf)
>  {
> @@ -99,7 +101,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  #endif
>  	n += sprintf(buf + n,
>  		       "Node %d Dirty:          %8lu kB\n"
> +		       "Node %d MetadataDirty:	%8lu kB\n"
>  		       "Node %d Writeback:      %8lu kB\n"
> +		       "Node %d MetaWriteback:  %8lu kB\n"

Between the enums and stat printing, the naming is kind of all over
the place. How about NR_META_DIRTY_BYTES and NR_META_WRITEBACK_BYTES
as a separate group than the existing dirty & writeback stats?

 	n += sprintf(buf + n,
 		       "Node %d Dirty:          %8lu kB\n"
 		       "Node %d Writeback:      %8lu kB\n"
+		       "Node %d MetaDirty:	%8lu kB\n"
+		       "Node %d MetaWriteback:  %8lu kB\n"

>  		       "Node %d FilePages:      %8lu kB\n"
>  		       "Node %d Mapped:         %8lu kB\n"
>  		       "Node %d AnonPages:      %8lu kB\n"
> @@ -119,7 +123,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  #endif
>  			,
>  		       nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
> +		       nid, BtoK(node_page_state(pgdat, NR_METADATA_DIRTY_BYTES)),
>  		       nid, K(node_page_state(pgdat, NR_WRITEBACK)),
> +		       nid, BtoK(node_page_state(pgdat, NR_METADATA_WRITEBACK_BYTES)),
>  		       nid, K(node_page_state(pgdat, NR_FILE_PAGES)),
>  		       nid, K(node_page_state(pgdat, NR_FILE_MAPPED)),
>  		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 56c8fda..aafdb11 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1801,6 +1801,7 @@ static struct wb_writeback_work *get_next_work_item(struct bdi_writeback *wb)
>  	return work;
>  }
>  
> +#define BtoP(x) ((x) >> PAGE_SHIFT)

Might be more readable inline:

> @@ -1809,6 +1810,7 @@ static unsigned long get_nr_dirty_pages(void)
>  {
>  	return global_node_page_state(NR_FILE_DIRTY) +
>  		global_node_page_state(NR_UNSTABLE_NFS) +
> +		BtoP(global_node_page_state(NR_METADATA_DIRTY_BYTES)) +

		global_node_page_state(NR_META_DIRTY_BYTES) / PAGE_SIZE +

>  		get_nr_dirty_inodes();
>  }

> @@ -80,7 +81,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		"SwapTotal:      %8lu kB\n"
>  		"SwapFree:       %8lu kB\n"
>  		"Dirty:          %8lu kB\n"
> +		"MetadataDirty:  %8lu kB\n"
>  		"Writeback:      %8lu kB\n"
> +		"MetaWriteback:  %8lu kB\n"

 		"Dirty:          %8lu kB\n"
 		"Writeback:      %8lu kB\n"
+		"MetaDirty:      %8lu kB\n"
+		"MetaWriteback:  %8lu kB\n"


>  		"AnonPages:      %8lu kB\n"
>  		"Mapped:         %8lu kB\n"
>  		"Shmem:          %8lu kB\n"
> @@ -139,7 +142,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		K(i.totalswap),
>  		K(i.freeswap),
>  		K(global_node_page_state(NR_FILE_DIRTY)),
> +		BtoK(global_node_page_state(NR_METADATA_DIRTY_BYTES)),
>  		K(global_node_page_state(NR_WRITEBACK)),
> +		BtoK(global_node_page_state(NR_META_WRITEBACK_BYTES)),

		K(global_node_page_state(NR_META_WRITEBACK_BYTES / PAGE_SIZE)),

and drop BtoK?

> @@ -34,6 +34,8 @@ typedef int (congested_fn)(void *, int);
>  enum wb_stat_item {
>  	WB_RECLAIMABLE,
>  	WB_WRITEBACK,
> +	WB_METADATA_DIRTY_BYTES,
> +	WB_METADATA_WRITEBACK_BYTES,

	WB_META_DIRTY_BYTES,
	WB_META_WRITEBACK_BYTES,

etc.
