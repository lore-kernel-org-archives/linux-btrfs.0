From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [LOCKING] 2.6.33-rc8 btrfs vs java
Date: Mon, 15 Feb 2010 10:56:53 -0500
Message-ID: <20100215155653.GC11057@think>
References: <201002141914.50955.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002141914.50955.edt@aei.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 14, 2010 at 07:14:50PM -0500, Ed Tomlinson wrote:
> Hi,
> 
> Found this in my log for 2.6.33-rc8.  Figgured it might be interesting since .33 is close.

The btrfs tree locking is very tricky for lockdep.  I don't quite see
how you could hit this one without also deadlocking the machine, unless
it is a false positive.

So, did you deadlock the machine? ;)

-chris
