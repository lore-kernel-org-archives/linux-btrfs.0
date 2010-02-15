From: Ed Tomlinson <edt@aei.ca>
Subject: Re: [LOCKING] 2.6.33-rc8 btrfs vs java
Date: Mon, 15 Feb 2010 17:19:22 -0500
Message-ID: <201002151719.22956.edt@aei.ca>
References: <201002141914.50955.edt@aei.ca> <20100215155653.GC11057@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Chris Mason <chris.mason@oracle.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100215155653.GC11057@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 15 February 2010 10:56:53 Chris Mason wrote:
> On Sun, Feb 14, 2010 at 07:14:50PM -0500, Ed Tomlinson wrote:
> > Hi,
> > 
> > Found this in my log for 2.6.33-rc8.  Figgured it might be interesting since .33 is close.
> 
> The btrfs tree locking is very tricky for lockdep.  I don't quite see
> how you could hit this one without also deadlocking the machine, unless
> it is a false positive.
> 
> So, did you deadlock the machine? ;)

No.  So maybe its a false positive?

Ed
