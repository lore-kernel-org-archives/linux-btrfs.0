From: Giuseppe Scrivano <gscrivano@gnu.org>
Subject: Re: BTRFS file clone support for cp
Date: Tue, 28 Jul 2009 22:06:35 +0200
Message-ID: <8763dcvagk.fsf@master.homenet>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>
	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>
	<4A6E3ADE.6050008@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: bug-coreutils@gnu.org, Jim Meyering <jim@meyering.net>,
	linux-btrfs@vger.kernel.org
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Return-path: <bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org>
In-Reply-To: <4A6E3ADE.6050008@draigBrady.com> (=?utf-8?Q?=22P=C3=A1draig?=
	Brady"'s message of "Tue, 28 Jul 2009 00:40:14 +0100")
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-coreutils>
List-Post: <mailto:bug-coreutils@gnu.org>
List-Help: <mailto:bug-coreutils-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=subscribe>
Errors-To: bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi P=C3=A1draig,


P=C3=A1draig Brady <P@draigBrady.com> writes:

> How different exactly?
> OK I tried this myself on F11 with inconclusive results.

I can't replicate it now, all tests I am doing report that blocks used
before and after the clone are the same.  Probably yesterday the
difference I noticed was in reality the original file flushed to the
disk.


> The above suggests that the clone does actually allocate space
> but btrfs isn't reporting it through statvfs correctly?

The same message appeared here too some days ago, though I cloned only
few Kb files, not much to fill the entire partition.


> If the clone does allocate space, then how can one
> clone without allocation which could be very useful
> for snapshotting for example?

I don't know if snapshotting is handled in the same way as a "clone",
but in this case it seems more obvious to me that no additional space
should be reported.


> Also I tried the above twice and both times got:
> http://www.kerneloops.org/submitresult.php?number=3D578993

I didn't get these errors.  I am using the btrfs git version.


Regards,
Giuseppe
