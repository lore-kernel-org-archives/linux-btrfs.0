From: Oystein Viggen <oysteivi@tihlde.org>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 15:28:02 +0200
Message-ID: <0339xpl4pp.fsf@msgid.viggen.net>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think>
	<4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think>
	<20100518005926.GM8635@think> <4BF28225.2000908@gmail.com>
	<20100518131304.GX8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

* [Chris Mason]=20

> I'm more than open to discussion on this one, but I don't see how:
>
> rm -f foo2
> dd if=3D/dev/zero of=3Dfoo bs=3D1M count=3D1000
> mv foo foo2
>
> Should be expected to write 1GB of data.

IIRC, the answer you're looking for is "it did with ext3 in the default
data=3Dordered mode".  Combine that with the ext3 data=3Dordered fsync(=
)
escalation where (again IIRC) fsync() tended to force a full sync() of
the file system, and it's not that difficult to see why someone would
program with the expectation above.

Anyway, there's still a question of if a new file system should emulate
the quirks of the old file system (read: be bug compatible), or if you
can just expect to be popular enough that userspace adapts to the new
order and lets you do The Right Thing instead.

=D8ystein
--=20
Outgoing mail is certified Virus Free.
=2E.of course, the virus would tell you the same thing..

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
