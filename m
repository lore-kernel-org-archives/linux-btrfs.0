Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35669 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751081AbdJMQGw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 12:06:52 -0400
Date: Fri, 13 Oct 2017 18:05:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 13/21] btrfs: remove delayed_ref_node from ref_head
Message-ID: <20171013160506.GY3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-14-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506714245-23072-14-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 03:43:57PM -0400, Josef Bacik wrote:
> This is just excessive information in the ref_head, and makes the code
> complicated.  It is a relic from when we had the heads and the refs in
> the same tree, which is no longer the case.  With this removal I've
> cleaned up a bunch of the cruft around this old assumption as well.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> @@ -91,8 +82,8 @@ struct btrfs_delayed_extent_op {
>   * reference count modifications we've queued up.
>   */
>  struct btrfs_delayed_ref_head {
> -	struct btrfs_delayed_ref_node node;
> -
> +	u64 bytenr, num_bytes;

In structures, one declaration per line is recommended. Fixed.
