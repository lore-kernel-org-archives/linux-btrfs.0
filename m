From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 22:29:55 +0200
Message-ID: <20090428202955.GM7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428052215.GA22921@cip.informatik.uni-erlangen.de> <1240912971.2149.5.camel@think.oraclecorp.com> <2a31deca0904280649w29d9cca8re9c0abc910ff99@mail.gmail.com> <1240927102.15136.0.camel@think.oraclecorp.com> <20090428140401.GA4223@cip.informatik.uni-erlangen.de> <1240939275.15136.20.camel@think.oraclecorp.com> <20090428201026.GH7217@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428201026.GH7217@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

* Thomas Glanzmann <thomas@glanzmann.de> [090428 22:10]:
> exactly. And if there is a way to retrieve the already calculated
> checksums from kernel land, than it would be possible to implement a
> ,,systemcall'' that gives the kernel a hint of a possible duplicated
> block (like providing a list of lists of blocks to the kernel that might
> be duplicated because they have the same checksum). Than the kernel code
> could dedup the block after byte-byte comparing it.

how hard would be to implement a systemcall that gets a list of blocks
and check if it is possible to dedup them (especially for the
implemented raid code, etc)?

Probably it would be smarter to report one set of blocks at a time
instead of a list of sets of blocks because than the systemcall would
take for ever to finish which is not really an issue but I assume that
the dedup systemcall needs to get a global lock that most probably
blocks any i/o operations?

        Thomas
