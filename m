Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:57366 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0LLDQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Dec 2010 22:16:40 -0500
MIME-Version: 1.0
In-Reply-To: <20101212023415.GG3059@thunk.org>
References: <20101209201359.GG2921@thunk.org> <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org> <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com> <20101212023415.GG3059@thunk.org>
From: Jon Nelson <jnelson@jamponi.net>
Date: Sat, 11 Dec 2010 21:16:18 -0600
Message-ID: <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
        Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 11, 2010 at 7:40 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Yes, indeed.  Is this in the virtualized environment or on real
> hardware at this point?  And how many CPU's do you have configured in
> your virtualized environment, and how memory memory?  Is having a
> certain number of CPU's critical for reproducing the problem?  Is
> constricting the amount of memory important?

Originally, I observed the behavior on really real hardware.

Since then, I have been able to reproduce it in VirtualBox and
qemu-kvm, with openSUSE 11.3 and KUbuntu. All of the more recent tests
have been with qemu-kvm.

I have one CPU configured in the environment, 512MB of memory.
I have not done any memory-constriction tests whatsoever.

> It'll be a lot easier if I can reproduce it locally, which is why I'm
> asking all of these questions.

On Sat, Dec 11, 2010 at 8:34 PM, Ted Ts'o <tytso@mit.edu> wrote:
> One experiment --- can you try this with the file system mounted with
> data=writeback, and see if the problem reproduces in that journalling
> mode?

That test is running now, first with encryption. I will report if it
shows problems. If it does, I will wait until I have been able to see
that a few times, and move to a no-encryption test. Typically, I have
to run quite a few more iterations of that test before problems show
up (if they will at all).

> I want to rule out (if possible) journal_submit_inode_data_buffers()
> racing with mpage_da_submit_io().  I don't think that's the issue, but
> I'd prefer to do the experiment to make sure.  So if you can use a
> kernel and system configuration which triggers the problem, and then
> try changing the mount options to include data=writeback, and then
> rerun the test, and let me know if the problem still reproduces, I'd
> be really grateful.


-- 
Jon
