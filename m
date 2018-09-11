Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34208 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbeILAtJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 20:49:09 -0400
From: Nick Terrell <terrelln@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH 0/3] btrfs: Add zstd support to btrfs
Date: Tue, 11 Sep 2018 19:48:09 +0000
Message-ID: <527ACA61-023A-4AD3-A5E3-8A07F2347E81@fb.com>
References: <20180828013654.1627080-1-terrelln@fb.com>
 <20180911102340.GD24025@twin.jikos.cz>
In-Reply-To: <20180911102340.GD24025@twin.jikos.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On Sep 11, 2018, at 3:23 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> On Mon, Aug 27, 2018 at 06:36:51PM -0700, Nick Terrell wrote:
>> Hi all,
>> 
>> This patch set imports the upstream kernel zstd library, patches it to work
>> in grub, adds zstd support to the btrfs module, and adds a test case. I've
>> separated the importing and patching of the upstream kernel zstd library
>> for ease of review.
>> 
>> Thanks to David Sterba for starting this project! I started my patch from
>> where he left off.
> 
> The first patch did not make it to vger.kernel.org mailinglist, which
> suggests that it's big, and possibly too big for merging. I did only a
> prototype to make it work, I'm afraid the patch won't be accepted.

Hmm. We need to import zstd into grub to use it, so we will need a large
patch somewhere in the stack.

The first patch is a copy as-is from the linux kernel, and the second applies
all the patches I need on top of it. I kept it that way for ease of review, so we
don't lose the handful of lines changed in the sea of additions.

Could we skip the first patch and replace it with a set of cp instructions to follow
for the baseline zstd files? Or is there another way to go about this? I'd really
appreciate any advice here.

> Your follow patches clean it up and IMHO go in the right direction, but
> I think this needs to be done from the beginning.

Thanks,
Nick
