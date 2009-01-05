From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 09:14:56 -0500
Message-ID: <1231164896.4290.19.camel@think.oraclecorp.com>
References: <1230765549.7538.8.camel@think.oraclecorp.com>
	 <20090103.013755.42849152.ryusuke@osrg.net>
	 <1230925087.7538.41.camel@think.oraclecorp.com>
	 <20090103.184406.54858118.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090103.184406.54858118.ryusuke@osrg.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-01-03 at 18:44 +0900, Ryusuke Konishi wrote:
> On Fri, 02 Jan 2009 14:38:07 -0500, Chris Mason 
>
> Btrfs seems to have other helpful code including pages/bio compression
> which may become separable, too.  And, this may be the same for
> pages/bio encryption/decryption code which would come next.  (I don't
> mention about the volume management/raid feature here to avoid getting
> off the subject, but it's likewise).
> 

The compression code is somewhat tied to the btrfs internals, but it
could be pulled out without too much trouble.  The big question there is
if other filesystems are interested in transparent compression support.

But, at the end of the day, most of the work is still done by the zlib
code.  The btrfs bits just organize pages to send down to zlib.

-chris


