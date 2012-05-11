From: Berke Durak <berke.durak@gmail.com>
Subject: Re: Minimum device size of 256 MiB?
Date: Fri, 11 May 2012 17:04:10 -0400
Message-ID: <CAALTfKDbXDUDq-vfsgEvzH+in9u11YckMMUGV=Mi7HKLMHeQSQ@mail.gmail.com>
References: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
	<20120511205032.GV21964@eightyeight.xmission.com>
	<CAALTfKCMUCjT0J2BfDZ1PwWQ9QKjCDk8WfE3tthdoq0Neg3PUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAALTfKCMUCjT0J2BfDZ1PwWQ9QKjCDk8WfE3tthdoq0Neg3PUA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2012 at 4:50 PM, Aaron Toponce
<aaron.toponce@gmail.com> wrote:
> I've noticed the same. I'm interested in researching the patterns
> the filesystem puts down on an encrypted container, but would like
> to use 1MB files as the block device for the filesystem. Looking for
> patterns in 256MB files is too expensive.

I think I may have found a workaround to my problem : use dm-zero to
create a sparse 256 MB device backed by a smaller partition.

I don't know if that would be useful for your crypto signature
analysis.

Of course it would be better if btrfs simply allowed smaller
partitions.

(Sorry for the previous mail it did not come out as intended.)
-- 
Berke Durak
