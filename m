Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:56982 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752780AbdGUShw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 14:37:52 -0400
Date: Fri, 21 Jul 2017 23:37:49 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
Message-ID: <20170721233749.5175d611@natsu>
In-Reply-To: <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
        <20170717183035.GR2866@twin.jikos.cz>
        <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Jul 2017 13:00:56 +0800
Anand Jain <anand.jain@oracle.com> wrote:

> 
> 
> On 07/18/2017 02:30 AM, David Sterba wrote:
> > So it basically looks good, I could not resist and rewrote the changelog
> > and comments. There's one code fix:
> > 
> > On Mon, Jul 17, 2017 at 04:52:58PM +0300, Timofey Titovets wrote:
> >> -static inline int inode_need_compress(struct inode *inode)
> >> +static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
> >>   {
> >>   	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >>
> >>   	/* force compress */
> >>   	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
> >> -		return 1;
> >> +		return btrfs_compress_heuristic(inode, start, end);
> 
> 
> 
> > This must stay 'return 1', if force-compress is on, so the change is
> > reverted.
> 
>   Initially I thought 'return 1' is correct, but looking in depth,
>   it is not correct as below..
> 
>   The biggest beneficiary of the estimating the compression ratio
>   in advance (heuristic) is when customers are using the
>   -o compress-force. But 'return 1' here is making them not to
>   use heuristic. So definitely something is wrong.

man mount says for btrfs:

    If compress-force is specified, all files will be compressed,  whether
    or  not they compress well.

So compress-force by definition should always compress all files no matter
what, and not use any heuristic. In fact it has no right to, as user forced
compression to always on. Returning 1 up there does seem right to me.

>   -o compress is about the whether each of the compression-granular bytes
>   (BTRFS_MAX_UNCOMPRESSED) of the inode should be tried to compress OR
>   just give up for the whole inode by looking at the compression ratio
>   of the current compression-granular.
>   This approach can be overridden by -o compress-force. So in
>   -o compress-force there will be a lot more efforts in _trying_
>   to compression than in -o compress. We must use heuristic for
>   -o compress-force.

Semantic and the user expectation of compress-force dictates to always
compress without giving up, even if it turns out to be slower and not providing
much benefit.

-- 
With respect,
Roman
