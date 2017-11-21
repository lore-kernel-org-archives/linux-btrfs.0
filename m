Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37802 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751877AbdKUCxg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 21:53:36 -0500
Date: Mon, 20 Nov 2017 21:53:29 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Ideas to reuse filesystem's checksum to enhance
 dm-raid1/10/5/6?
Message-ID: <20171121025329.ll72kg6yqkjeaz5o@thunk.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRUGEdu13RCKFb6uZQ3UCzoAByhu97FdwQoFPxvsOua0Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 03:32:05PM -0700, Chris Murphy wrote:
> 
> XFS by default does metadata csums. But ext4 doesn't use it for either
> metadata or the journal by default still, it is still optional. So for
> now it mainly benefits XFS.

Metadata checksums are enabled by default in the version of e2fsprogs
shipped by Debian.  Since there were no real problems reported by
Debian users, in the next release of e2fsprogs, coming soon, it will
be enabled by default for all new ext4 file systems.

Regards,

					- Ted
