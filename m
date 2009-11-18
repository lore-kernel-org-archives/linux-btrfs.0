From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: Somewhat borked filesystem in need of fixing
Date: Wed, 18 Nov 2009 15:20:08 +0200
Message-ID: <87my2k2cmv.fsf@kiiro.naked.iki.fi>
References: <87r5rw3mj3.fsf@kiiro.naked.iki.fi>
	<3d0408630911171840w3ee97037xa9fd5a1ee89f7253@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Yan\, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630911171840w3ee97037xa9fd5a1ee89f7253@mail.gmail.com> (Zheng Yan's message of "Wed\, 18 Nov 2009 10\:40\:57 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

"Yan, Zheng " <yanzheng@21cn.com> writes:
> You can try mounting the FS in read only mode and copying files out.
> If you still get that error, try making verify_parent_transid() in disk-io.c
> always return 0. These are all we can do now.

Tried mounting it in read only mode, same problem:

  [176994.933016] __ratelimit: 92171 callbacks suppressed
  [176994.933021] parent transid verify failed on 39669760 wanted 5946 found 5944

However, I will keep the filesystem in storage, so you can tell me when
you wish to start working on the btrfsck side of things. I can run
different test versions and help debug things until btrfsck is able to
fix the filesystem.

Personally, I consider the biggest barrier in adopting new filesystems
for use to be the quality of their fsck. Checksums and metadata
checksums do not help against programmatic corruption of data structures
- and in my opinion, that will happen at some point, either via bugs in
the code or memory corruption - and a filesystem needs to be able to
survive that.

-- Naked
