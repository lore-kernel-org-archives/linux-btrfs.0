Return-Path: <SRS0=UCOX=WY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E5EC3A5A1
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Aug 2019 12:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C614722DA7
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Aug 2019 12:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfH1MG3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 08:06:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:35978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfH1MG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Aug 2019 08:06:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B34CDAF0D;
        Wed, 28 Aug 2019 12:06:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04D2ADA809; Wed, 28 Aug 2019 14:06:50 +0200 (CEST)
Date:   Wed, 28 Aug 2019 14:06:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH 5/5] Btrfs: add ioctl for directly writing compressed
 data
Message-ID: <20190828120650.GZ2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1565900769.git.osandov@fb.com>
 <78747c3028ce91db9856e7fbd98ccbb2609acdc6.1565900769.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78747c3028ce91db9856e7fbd98ccbb2609acdc6.1565900769.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 15, 2019 at 02:04:06PM -0700, Omar Sandoval wrote:
>  #define BTRFS_IOC_SEND_32 _IOW(BTRFS_IOCTL_MAGIC, 38, \
>  			       struct btrfs_ioctl_send_args_32)
> +
> +struct btrfs_ioctl_compressed_pwrite_args_32 {
> +	__u64 offset;		/* in */
> +	__u32 compressed_len;	/* in */
> +	__u32 orig_len;		/* in */
> +	__u32 compress_type;	/* in */
> +	__u32 reserved[9];
> +	compat_uptr_t buf;	/* in */
> +} __attribute__ ((__packed__));
> +
> +#define BTRFS_IOC_COMPRESSED_PWRITE_32 _IOW(BTRFS_IOCTL_MAGIC, 63, \
> +				 struct btrfs_ioctl_compressed_pwrite_args_32)

Note that the _32 is a workaround for a mistake in the send ioctl
definitions that slipped trhough. Any pointer in the structure changes
the ioctl number on 32bit and 64bit.

But as the raw data ioctl is new there's point to copy the mistake. The
alignment and width can be forced eg. like

> +	void __user *buf;	/* in */

	union {
		void __user *buf;
		__u64 __buf_alignment;
	};

This allows to user buf as a buffer without casts to a intermediate
type.
