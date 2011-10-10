From: David Sterba <dave@jikos.cz>
Subject: Re: btrfs root + mount subvolid=0 problem
Date: Mon, 10 Oct 2011 12:20:28 +0200
Message-ID: <20111010102028.GD17912@twin.jikos.cz>
References: <CAG1y0scXmy=DAGisOh9_6=LzueBhM5VMxpPWGeNPc+iOEc3scA@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scXmy=DAGisOh9_6=LzueBhM5VMxpPWGeNPc+iOEc3scA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2011 at 02:30:30PM +0700, Fajar A. Nugraha wrote:
> This happens both with natty's 2.6.38-11-generic and kernel 3.0.4
> (backported from oneiric). Does anyone know if this is a know problem,
> or how to get further information to fix this?

I'm afraid with the kernels that old, nobody will try to fix it unless
you reproduce it on the most recent kernels.

Do you see any relevant messages in the log before/while the ls is
stuck? I'd be good to know where excatly the ls is stuck by 'cat
/proc/<lspid>/stack', and if it's in D state, possibly gethering stacks
of all such processes.

I have seen problems with mounting subvolumes when there is a
non-toplevel one set as deafult, but this was more related to the
'subvol' option, subvolid does not suffer from this.


david
