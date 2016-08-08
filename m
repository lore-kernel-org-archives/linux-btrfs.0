Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41345 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbcHHVDc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Aug 2016 17:03:32 -0400
Subject: Re: [lkp] [dm flakey] 99f3c90d0d: WARNING: CPU: 20 PID: 1027 at
 fs/btrfs/extent-tree.c:2973 btrfs_run_delayed_refs+0x2c5/0x2f0 [btrfs]
To: Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <xiaolong.ye@intel.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
References: <20160808080034.GA8581@yexl-desktop>
 <CA+55aFzFFKaTMfDUmrV5QvLq0PsmmNrRYqVOLLujyQq7oa4Nkg@mail.gmail.com>
CC: Mike Snitzer <snitzer@redhat.com>, Akira Hayakawa <ruby.wktk@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <652374b9-1457-0409-b5eb-b253efb7d5fd@fb.com>
Date: Mon, 8 Aug 2016 17:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzFFKaTMfDUmrV5QvLq0PsmmNrRYqVOLLujyQq7oa4Nkg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/08/2016 02:27 PM, Linus Torvalds wrote:
> This report should probably have gone to the btrfs people, although it
> doesn't really look like a bug.
>
> It looks like it's just dm-flakey now returning more errors, and
> causing btrfs to complain more.
>
> Which seems entirely expected.
>
> Maybe the robot just was testing a error case that didn't actually
> happen before.

Yeah, this warning in btrfs is much too verbose.  I've been meaning to 
toss it under a debugging conditional because it makes common hardware 
problems look like software problems.  It also spams dmesg during xfstests.

Thanks, I've been meaning to fix it up.

-chris
