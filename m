Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6572 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbdK3EaP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 23:30:15 -0500
Date: Thu, 30 Nov 2017 12:30:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Terrell <terrelln@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Jeff Mahoney <jeffm@suse.com>,
        David Howells <dhowells@redhat.com>, Liu Bo <bo.li.liu@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@01.org" <lkp@01.org>
Subject: Re: [btrfs_mount] general protection fault: 0000 [#1] SMP
Message-ID: <20171130043009.qoetvxeokkbqyvsx@wfg-t540p.sh.intel.com>
References: <20171130022115.5gyvncjrnn2377ph@wfg-t540p.sh.intel.com>
 <3A84FF7B-0390-41EC-862D-5F83C2A656FA@fb.com>
 <CA+55aFzOgPOV+UZu6jCJMrbxOSBvn1UdxC5phAwC7n8n4asR5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <CA+55aFzOgPOV+UZu6jCJMrbxOSBvn1UdxC5phAwC7n8n4asR5w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 06:44:43PM -0800, Linus Torvalds wrote:
>On Wed, Nov 29, 2017 at 6:38 PM, Nick Terrell <terrelln@fb.com> wrote:
>>
>> The stack trace looks like the bug fixed by
>>
>> Qu Wenruo:
>>     btrfs: Fix wild memory access in compression level parser [1]
>>
>> That fix looks to be included in the pull request for 4.15-rc2 [2].
>
>Which got merged earlier today. So maybe instead of a bisection, just
>test the current git tree?

Sure. The 1 hour tests finished on your latest merge and the error
no long shows up there.

Regards,
Fengguang
