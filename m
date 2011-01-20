From: Josef Bacik <josef@redhat.com>
Subject: Re: [2.6.38-rc1] btrfs potential false-positive lockdep report...
Date: Thu, 20 Jan 2011 11:08:49 -0500
Message-ID: <20110120160849.GA6609@dhcp231-156.rdu.redhat.com>
References: <AANLkTinTkAtUkZApi-EMpTx-R7sBagLnd4uYnUTL5Lek@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinTkAtUkZApi-EMpTx-R7sBagLnd4uYnUTL5Lek@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 20, 2011 at 10:53:51AM +0700, Daniel J Blueman wrote:
> I saw a lockdep report with an instrumented 2.6.38-rc1 kernel [1].
> 
> Checking the code, it looks more likely a false-positive due to the
> lock manipulation to satisfy lockdep, since CONFIG_DEBUG_LOCK_ALLOC is
> defined.
> 
> Is this the case?
> 

Yeah these pop up every once and a while, its safe to just ignore it.  Thanks,

Josef
