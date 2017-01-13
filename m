Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([188.40.36.198]:47036 "EHLO
        mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdAMNcS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jan 2017 08:32:18 -0500
Subject: Re: Announcing btrfs-dedupe 1.1.0
To: James Pharaoh <james@pharaoh.uk>, linux-btrfs@vger.kernel.org
References: <b81e1e04-394b-06a8-d4cb-acfe436a8423@pharaoh.uk>
From: Robert Krig <robert.krig@render-wahnsinn.de>
Message-ID: <08ac7d06-367e-a2ec-dc15-ee71aa3dada2@render-wahnsinn.de>
Date: Fri, 13 Jan 2017 13:56:28 +0100
MIME-Version: 1.0
In-Reply-To: <b81e1e04-394b-06a8-d4cb-acfe436a8423@pharaoh.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, could you include some build instructions for people that are
unfamiliar with compiling rust code?


On 08.01.2017 17:57, James Pharaoh wrote:
> Hi everyone,
>
> I'm pleased to announce a new version of my btrfs-dedupe tool, written
> in rust, available here:
>
> http://btrfs-dedupe.com/
>
> Binary packages built on ubuntu (probably will work elsewhere, but
> haven't tried this), are available at:
>
> https://dist.wellbehavedsoftware.com/btrfs-dedupe/
>
> This version is considered ready for production use. It maintains a
> compressed database of the filesystem state, and it tracks file
> metadata, hashes file contents, and the extent-map contents, in order
> to work out what needs to be deduplicated.
>
> This is a whole-file deduplication tool, similar to bedup, but since
> it is written in Rust, and designed to work with the dedupe ioctl, I
> think it's more suitable for production use.
>
> As normal for open source, this comes without any warranty etc, but
> the only updates are performed via the defragment and deduplication
> ioctls, and so assuming they work correctly then this should not cause
> any corruption.
>
> Please feel free to contact me with any questions/problems.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

