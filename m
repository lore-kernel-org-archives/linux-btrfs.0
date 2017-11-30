Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:40128 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbdK3Coo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 21:44:44 -0500
MIME-Version: 1.0
In-Reply-To: <3A84FF7B-0390-41EC-862D-5F83C2A656FA@fb.com>
References: <20171130022115.5gyvncjrnn2377ph@wfg-t540p.sh.intel.com> <3A84FF7B-0390-41EC-862D-5F83C2A656FA@fb.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Nov 2017 18:44:43 -0800
Message-ID: <CA+55aFzOgPOV+UZu6jCJMrbxOSBvn1UdxC5phAwC7n8n4asR5w@mail.gmail.com>
Subject: Re: [btrfs_mount] general protection fault: 0000 [#1] SMP
To: Nick Terrell <terrelln@fb.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        David Howells <dhowells@redhat.com>, Liu Bo <bo.li.liu@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@01.org" <lkp@01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 6:38 PM, Nick Terrell <terrelln@fb.com> wrote:
>
> The stack trace looks like the bug fixed by
>
> Qu Wenruo:
>     btrfs: Fix wild memory access in compression level parser [1]
>
> That fix looks to be included in the pull request for 4.15-rc2 [2].

Which got merged earlier today. So maybe instead of a bisection, just
test the current git tree?

               Linus
