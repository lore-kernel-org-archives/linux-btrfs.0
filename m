From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Thu, 25 Aug 2011 19:01:23 -0400
Message-ID: <CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>
References: <4E54F884.9090004@cyberwizzard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Berend Dekens <btrfs@cyberwizzard.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E54F884.9090004@cyberwizzard.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2011 at 9:11 AM, Berend Dekens <btrfs@cyberwizzard.nl> wrote:
[snip]
> I thought the idea of COW was that whatever happens, you can always mount in
> a semi-consistent state?
[snip]


It seems to me that if someone created a block device which recorded
all write operations a rather excellent test could be constructed
where a btrfs filesystem is recorded under load and then every partial
replay is mounted and checked for corruption/data loss.

This would result in high confidence that no power loss event could
destroy data given the offered load assuming well behaved
(non-reordering hardware).  If it recorded barrier operations the a
tool could also try many (but probably not all) permissible
reorderings at every truncation offset.

It seems to me that the existence of this kind of testing is something
that should be expected of a modern filesystem before it sees
widescale production use.
