Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BA0C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 15:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC1D206B8
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 15:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfDCPmr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:42:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:42028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725990AbfDCPmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 11:42:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41186B035
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 15:42:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 00201DA8D8; Wed,  3 Apr 2019 17:43:54 +0200 (CEST)
Date:   Wed, 3 Apr 2019 17:43:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: trace: Introduce trace events for sleepable
 tree lock
Message-ID: <20190403154354.GR29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190402094554.8353-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402094554.8353-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 05:45:54PM +0800, Qu Wenruo wrote:
> There are two tree lock events which can sleep:
> - btrfs_tree_read_lock()
> - btrfs_tree_lock()
> 
> Sometimes we may need to look into the concurrency picture of the fs.
> For that case, we need the execution time of above two functions and the
> owner of @eb.
> 
> Here we introduce a trace events for user space tools like bcc, to get
> the execution time of above two functions, and get detailed owner info
> where eBPF code can't.
> 
> All the overhead is hidden behind the trace events, so if events are not
> enabled, there is no overhead.
> 
> Also, since this patch and later user space tool only cares about the
> execution time and owner, other info like bytenr is ignored in this
> events.

The time is definetelly the interesting part here, I'm thinking if the
block number could also provide some useful hints. The gathered trace
data can be used to group by blocks to compare the times, or see the
histogram of times.

The block at minimum would be useful and I don't want to add more
information there, like level or nritems. In case we do want that
information, a heavier tracepoint version should be added with all the
other data.

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Hide all ktime_get_ns() call behind trace events
>   So there will be no overhead if trace events are not enabled.
> ---
>  fs/btrfs/locking.c           | 12 ++++++++++++
>  include/trace/events/btrfs.h | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
> index 6df03ba36026..67b77f1d113e 100644
> --- a/fs/btrfs/locking.c
> +++ b/fs/btrfs/locking.c
> @@ -158,6 +158,10 @@ void btrfs_clear_lock_blocking_write(struct extent_buffer *eb)
>   */
>  void btrfs_tree_read_lock(struct extent_buffer *eb)
>  {
> +	u64 start_ns = 0;
> +
> +	if (trace_btrfs_tree_read_lock_enabled())
> +		start_ns = ktime_get_ns();
>  again:
>  	BUG_ON(!atomic_read(&eb->blocking_writers) &&
>  	       current->pid == eb->lock_owner);
> @@ -174,6 +178,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
>  		BUG_ON(eb->lock_nested);
>  		eb->lock_nested = true;
>  		read_unlock(&eb->lock);
> +		trace_btrfs_tree_read_lock(eb, start_ns);
>  		return;
>  	}
>  	if (atomic_read(&eb->blocking_writers)) {
> @@ -184,6 +189,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
>  	}
>  	btrfs_assert_tree_read_locks_get(eb);
>  	btrfs_assert_spinning_readers_get(eb);
> +	trace_btrfs_tree_read_lock(eb, start_ns);
>  }
>  
>  /*
> @@ -299,6 +305,11 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
>   */
>  void btrfs_tree_lock(struct extent_buffer *eb)
>  {
> +	u64 start_ns = 0;
> +
> +	if (trace_btrfs_tree_lock_enabled())
> +		start_ns = ktime_get_ns();
> +
>  	WARN_ON(eb->lock_owner == current->pid);
>  again:
>  	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
> @@ -312,6 +323,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
>  	btrfs_assert_spinning_writers_get(eb);
>  	btrfs_assert_tree_write_locks_get(eb);
>  	eb->lock_owner = current->pid;
> +	trace_btrfs_tree_lock(eb, start_ns);
>  }
>  
>  /*
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index 8b12753fee78..406a71571254 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -2005,6 +2005,42 @@ TRACE_EVENT(btrfs_convert_extent_bit,
>  		  __print_flags(__entry->clear_bits, "|", EXTENT_FLAGS))
>  );
>  
> +DECLARE_EVENT_CLASS(btrfs_sleep_tree_lock,
> +	TP_PROTO(const struct extent_buffer *eb, u64 start_ns),
> +
> +	TP_ARGS(eb, start_ns),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	start_ns	)
> +		__field(	u64,	end_ns		)
> +		__field(	u64,	owner		)
> +		__field(	int,	is_log_tree	)
> +	),
> +
> +	TP_fast_assign_btrfs(eb->fs_info,
> +		__entry->start_ns	= start_ns;
> +		__entry->end_ns		= ktime_get_ns();
> +		__entry->owner		= btrfs_header_owner(eb);
> +		__entry->is_log_tree	= (eb->log_index >= 0);
> +	),
> +
> +	TP_printk_btrfs("start_ns=%llu end_ns=%llu owner=%llu is_log_tree=%d",
> +		__entry->start_ns, __entry->end_ns, __entry->owner,
> +		__entry->is_log_tree)

I think the delta between start_ns and end_ns should be printed too, so
it's obvious without further processing:

	TP_printk_btrfs("start_ns=%llu end_ns=%llu diff=%llu owner=%llu is_log_tree=%d",
