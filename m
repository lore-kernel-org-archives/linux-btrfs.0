From: Theodore Tso <tytso@mit.edu>
Subject: Re: Btrfs v0.16 released
Date: Thu, 14 Aug 2008 19:44:59 -0400
Message-ID: <20080814234458.GD13048@mit.edu>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218747656.15342.439.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I spent a bunch of time hammering on different ways to fix this without
> increasing nr_requests, and it was a mixture of needing better tuning in
> btrfs and needing to init mapping->writeback_index on inode allocation.
> 
> So, today's numbers for creating 30 kernel trees in sequence:
> 
> Btrfs defaults                  57.41 MB/s
> Btrfs dup no csum               74.59 MB/s 
> Btrfs no duplication            76.83 MB/s
> Btrfs no dup no csum no inline  76.85 MB/s

What sort of script are you using?  Basically something like this?

for i in `seq 1 30` do
    mkdir $i; cd $i
    tar xjf /usr/src/linux-2.6.28.tar.bz2
    cd ..
done

						- Ted
