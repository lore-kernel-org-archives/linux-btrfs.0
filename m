From: cwillu <cwillu@cwillu.com>
Subject: Re: Slow snapshot deletion
Date: Mon, 1 Aug 2011 16:41:10 -0600
Message-ID: <CAE5mzvgNYHkq6ETKkbs7GDryN4LmU8uw_wwTCDhKseubjxRfMQ@mail.gmail.com>
References: <20110728200444.GA30801@untroubled.org>
	<1311884805-sup-7662@shiny>
	<20110801222604.GA3529@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110801222604.GA3529@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2011 at 4:26 PM, Bruce Guenter <bruce@untroubled.org> wr=
ote:
> On Thu, Jul 28, 2011 at 04:28:04PM -0400, Chris Mason wrote:
>> The slow performance is probably coming from reading in the metadata
>> associated with the snapshot extents. =C2=A0The new readahead extent=
ions from
>> Arne should help once we've adapted them to it. =C2=A0The easiest wa=
y to make
>> sure is to hit sysrq-w a few times while it is slow (or run a patche=
d
>> latencytop).
>
> We shut down the rsync backups for now, and are waiting for the
> snapshots to complete deletion so we can unmount the filesystem to
> reboot (missing kernel options for latencytop). =C2=A0In the mean tim=
e I hit
> SysRq-W quite a number of times, and nothing is showing up in kernel

The keystroke should be alt-sysrq-w.

> messages. =C2=A0However, btrfs-cleaner and/or btrfs-transaction (some=
times
> both, sometimes just one) have been running high in top, taking up al=
l
> the CPU time.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
