From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Tue, 16 Feb 2010 12:09:34 -0500
Message-ID: <4B7AD14E.9050801@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B77521F.2060105@gmail.com> <20100215164255.GG11057@think> <4B799DF7.9090008@gmail.com> <20100216160107.GF3497@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100216160107.GF3497@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> [ use i_mutex for reads? ]
> 
> But, we already need the code that btrfs_page_mkwrite uses.  It should
> be enough to wait for the ordered extents and have the extent range
> locked.

You don't mean have the lock_extent active while I issue the
btrfs_wait_ordered_range as I found that was a deadlock when
I tried it before.  AFAICS without i_mutex I have to do this
all unlocked and hope they are not being stupid.

> The cost of i_mutex on parallel readers + high speed devices can be
> surprising.

OK, I did not have i_mutex until the very last days of coding when
I could not find any way to fix my problems.  I'll see if I can
come up with something that makes Josef think my vector code is
pretty by comparison ;)

jim
