Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rei.romanrm.net ([172.104.66.239]:36058 "EHLO rei.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752519AbeENJjh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 05:39:37 -0400
Date: Mon, 14 May 2018 14:39:33 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
Message-ID: <20180514143933.60b3bb76@natsu>
In-Reply-To: <ea90a7da-a055-6879-e64f-f0f3bca81a23@suse.com>
References: <20180514070210.27047-1-wqu@suse.com>
 <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu>
 <ea90a7da-a055-6879-e64f-f0f3bca81a23@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 14 May 2018 11:36:26 +0300
Nikolay Borisov <nborisov@suse.com> wrote:

> So what made you have these expectation, is it codified somewhere
> (docs/man pages etc)? I'm fine with that semantics IF this is what
> people expect.

"Compression ...does not work for NOCOW files":
https://btrfs.wiki.kernel.org/index.php/Compression

The mount options man page does not say that the NOCOW attribute of files will
be disregarded with compress-force.  It only mentions interaction with the
nodatacow and nodatasum mount options. So I'd expect the attribute to still
work and prevent compression of NOCOW files.

> Now the question is why people grew up to have this expectation and not the
> other way round? IMO force_compress should really disregard everything else

Both are knobs that the user needs to explicitly set, the difference is that
the +C attribute is fine-grained and the mount option is global. If they are
set by the user to conflicting values, it seems more useful to have the
fine-grained control override the global one, not the other way round.

-- 
With respect,
Roman
