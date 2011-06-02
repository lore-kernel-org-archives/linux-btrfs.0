From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/9] some fixes for bugs spotted by valgrind
Date: Thu, 02 Jun 2011 13:17:55 -0700
Message-ID: <m262oot2bw.fsf@firstfloor.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
	<20110531221037.0454f16e@sf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Sergei Trofimovich <slyfox@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110531221037.0454f16e@sf> (Sergei Trofimovich's message of
	"Tue, 31 May 2011 22:10:37 +0300")
List-ID: <linux-btrfs.vger.kernel.org>

Sergei Trofimovich <slyfox@gentoo.org> writes:
>
> Am I too paranoid about the issue?

It sounds weird, because if the kernel would really checksum
mutexes on disk you would have a lot of on disk
format incompatibility between different kernel versions
(e.g. between lockdep and normal kernels or kernels
running on different architectures)

If it would really happen (no opinion on that) it would
be a serious bug.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
