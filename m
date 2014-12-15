Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31336 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbaLOB0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Dec 2014 20:26:05 -0500
Message-ID: <548E38A6.4030301@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 09:25:58 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com> <20141210123750.GA27601@twin.jikos.cz> <5488EA3D.9080905@cn.fujitsu.com> <CAL3q7H6gmX9wZFxjb_ryHjzbaqq_5W+e9aHj+FNqcfsbuRNstw@mail.gmail.com> <548A378F.6020101@cn.fujitsu.com> <CAL3q7H6OWFRPdWeKVABbbdAigW6PAx4oFF6=q8vSU-s0Y7EPzQ@mail.gmail.com> <20141212153147.GR27601@twin.jikos.cz>
In-Reply-To: <20141212153147.GR27601@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The binary image dump is definitely working, but the size still seems 
not so good.... :-(

For my case, 64M contains my /etc copy even after xz with -9 option, the 
size is still about 2.8M. (although
xz is already doing great job).
I know there is even larger btrfs-image dump case here, but several 
megabytes size binary still seems
not so good for me.

But on the other hand, btrfs-image with -c9 dump the uncorrupted fs 
image to less than 200K.
The point is that, I know exactly which leaf I can corrupt to produce 
the corrupted image and in fact,
I am using my leaf corruption patch to do 
it(https://patchwork.kernel.org/patch/5170691/), even
without the patch, I can still figure out where the leaf is and can use 
dd to corrupt the leaf.

So why not change the test cases to following method?
1. Untar the tar.gz, which contains the corruption script + a 
btrfs-image dump.
2. Exec the corruption script to corrupt the image (Of course, 
btrfs-corrupte-image must be able to corrupt it)
3. Do the test.

The trick may be step 2., which means every new repair function should 
have a corresponding corrupt function.

The above is just a advice, I will still submit the binary image dump 
for now.

Thanks,
Qu

-------- Original Message --------
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Date: 2014年12月12日 23:31
> On Fri, Dec 12, 2014 at 08:34:09AM +0000, Filipe David Manana wrote:
>> Very simple solution.
>>
>> Do:
>>
>> 1) Create an empty file;
>> 2) Use it as the backing file for a loop device;
>> 3) Run mkfs.btrfs against the loop device;
>> 4) Mount it;
>> 5) Populate the fs;
>> 6) Umount it;
>> 7) Corrupt some nodes or leafs (by zeroing them out for e.g.);
>> 8) Create a tarball from the backing file like this: ZX_OPT=-9 tar
>> cJSvf foobar.tar.xz run.sh backing_file
>> 9) Add the tarball to the fsck-tests directory;
>> 10) Make the test run fsck against the backing file extracted from the
>> tarball - fsck can operate against regular files, and not only against
>> devices.
> I made a few scripts that help to automate most of the steps (no
> populating or fuzzing), attached.

