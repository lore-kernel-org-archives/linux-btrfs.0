Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36840 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbaEPBXy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 21:23:54 -0400
Message-ID: <1400203051.21609.1.camel@localhost.localdomain>
Subject: Re: [PATCH 1/2] btrfs-progs: add sys_chunk_array and backup roots
 info to show-super
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Fri, 16 May 2014 09:17:31 +0800
In-Reply-To: <20140515163538.GP6917@twin.jikos.cz>
References: <1399518238-3337-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140515163538.GP6917@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-05-15 at 18:35 +0200, David Sterba wrote:
> On Thu, May 08, 2014 at 11:03:57AM +0800, Gui Hecheng wrote:
> > Add sys chunk array and backup roots info if the new option '-f'
> > if specified.
> > This may be useful for debugging sys_chunk related issues.
> 
> Sounds useful. One comment below.
> 
> > +static void print_sys_chunk_array(struct btrfs_super_block *sb)
> > +{
> > +	struct extent_buffer *buf;
> > +	struct btrfs_disk_key *disk_key;
> > +	struct btrfs_chunk *chunk;
> > +	struct btrfs_key key;
> > +	u8 *ptr, *array_end;
> > +	u32 num_stripes;
> > +	u32 len = 0;
> > +	int i = 0;
> > +
> > +	buf = malloc(sizeof(*buf) + sizeof(*sb));
> 
> Unchecked memory allocation

Yes, indeed. I'll resend. Thanks, David.

> > +	write_extent_buffer(buf, sb, 0, sizeof(*sb));
> > +	ptr = sb->sys_chunk_array;
> > +	array_end = ptr + btrfs_super_sys_array_size(sb);
> > +
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


