From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: does btrfs have RAID I/O throughput (un)limiting sysctls, similar
	to md?
Date: Sat, 6 Feb 2010 06:48:34 -0800
Message-ID: <c67eed301002060648p436a7347w3c7189e385ed79bc@mail.gmail.com>
References: <c67eed301002051637p1288e120tb37c649ac44d40c@mail.gmail.com>
	 <6278d2221002060510i947059bx12697ba0a4f5e4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2221002060510i947059bx12697ba0a4f5e4c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 6, 2010 at 5:10 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> These proc entries affect just array reconstruction, not general I/O
> performance/throughput, so affect just an edge-case of applications
> requiring maximum latency/minimum throughout guarantees.

although i'd 1st seen the perf hit at the (re)construction stage, i
didn't recognize that the sysctls were limited to that case.

so, iiuc, btrfs has no such issues?

thanks for clarifying!
