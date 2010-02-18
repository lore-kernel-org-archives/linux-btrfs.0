From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Thu, 18 Feb 2010 20:54:05 +0000 (UTC)
Message-ID: <loom.20100218T215310-779@post.gmane.org>
References: <loom.20100212T220341-877@post.gmane.org> <20100217141813.GH29430@think> <loom.20100218T013258-629@post.gmane.org> <20100218150238.GL10559@think> <loom.20100218T183230-637@post.gmane.org> <20100218204843.GW10559@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> oracle.com> writes:
> I think the btrfsck output is missing.  It sounds like we'll survive if
> we just skip this part of the log replay.  I'll cook a patch based on
> the btrfsck output.

It was inline in my first message, immediately after the BUG trace.

