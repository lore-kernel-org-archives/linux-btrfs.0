From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 01:21:54 -0700
Message-ID: <20090730082153.GC2435@mail.oracle.com>
References: <8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>
	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>
	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>
	<20090730005702.GA32157@mail.oracle.com>
	<87fxcevcuy.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bug-coreutils@gnu.org, linux-btrfs@vger.kernel.org,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	Giuseppe Scrivano <gscrivano@gnu.org>, Chris Mason <chris.mason@oracle.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org>
In-Reply-To: <87fxcevcuy.fsf@meyering.net>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-coreutils>
List-Post: <mailto:bug-coreutils@gnu.org>
List-Help: <mailto:bug-coreutils-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=subscribe>
Errors-To: bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 30, 2009 at 09:39:17AM +0200, Jim Meyering wrote:
> Joel Becker wrote:
> > 	I've cooked up 'ln -r' for reflinks, which works for ln(1) but
> > not for cp(1).
> 
> Thanks.  I haven't looked, but after reading about the reflink syscall
> [http://lwn.net/Articles/332802/] had come to the same conclusion:
> this feature belongs with ln rather than with cp.
> 
> Besides, putting the new behavior on a new option avoids
> the current semantic change we would otherwise induce in cp.

	Well, I don't see any reason cp(1) can't take advantage of
reflink(2).  I just think that cp(1) should look at reflink(2) as an
optimization, not a specific methodology.
	What do I mean?  If you want to say "I know what a reflink is,
and that's exactly what I want", you want "ln -r".  But say you want a
"cp --snap" that tries to take a snapshot regardless of the backend.  It
could use reflink(2) on filesystems that support it, or perhaps a
passthrough call to the underlying storage, or who knows what.  I can
also imagine a "cp --shallow" that is "if you can cow, do it, otherwise
do a normal cp".

Joel

-- 

"I think it would be a good idea."  
        - Mahatma Ghandi, when asked what he thought of Western
          civilization

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
