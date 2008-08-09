From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Btrfs v0.16 released
Date: Sat, 9 Aug 2008 03:23:22 +0200
Message-ID: <20080809012322.GF9038@one.firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <20080808215625.GC9038@one.firstfloor.org> <20080809011905.GB9967@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080809011905.GB9967@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

> In theory, if the elevator was smart enough, it could actually help
> read seekiness; there are two copies of the metadata, and it shouldn't

That assumes the elevator actually knows what is nearby? I thought
that wasn't that easy with modern disks with multiple spindles
and invisible remapping, not even talking about RAID
arrays looking like disks.

-Andi
