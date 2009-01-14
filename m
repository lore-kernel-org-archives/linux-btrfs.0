From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 22:50:59 +0100
Message-ID: <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com>
References: <1231952436.14825.28.camel@laptop>
	 <20090114105300.66bd014d.akpm@linux-foundation.org>
	 <20090114190008.GA13203@elte.hu>
	 <20090114113638.c818fcf8.akpm@linux-foundation.org>
	 <20090114201435.GA6519@elte.hu>
	 <20090114123017.9acf42d7.akpm@linux-foundation.org>
	 <20090114205122.GC6519@elte.hu>
	 <20090114130642.cf2b18b2.akpm@linux-foundation.org>
	 <20090114211458.GD6519@elte.hu> <20090114214158.GA9992@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, chris.mason@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com,
	dmitry.adamushko@gmail.com, hannes@cmpxchg.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114214158.GA9992@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2009 at 22:41, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > You just disproved your own case :(
>>
>> how so? 80% is not enough? I also checked Fedora and it has
>> SCHED_DEBUG=y in its kernel rpms.
>
> Ubuntu has CONFIG_SCHED_DEBUG=y as well in their kernels.

$ cat /etc/SuSE-release
openSUSE 11.1 (x86_64)
VERSION = 11.1

$ uname -a
Linux nga 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64
x86_64 x86_64 GNU/Linux

$ zgrep SCHED_DEBUG /proc/config.gz
CONFIG_SCHED_DEBUG=y

$ zgrep DEBUG_MUTEX /proc/config.gz
# CONFIG_DEBUG_MUTEXES is not set

Kay
