From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressed Filesystem
Date: Tue, 28 Oct 2008 13:46:21 -0400
Message-ID: <1225215981.6448.178.camel@think.oraclecorp.com>
References: <20081027145401.GB10896@tux64-03>
	 <1225208847.6448.172.camel@think.oraclecorp.com>
	 <20081028163337.GA8488@tux64-02>
	 <1225215517.6448.176.camel@think.oraclecorp.com>
	 <49074EA3.2080801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org,
	balajirrao@gmail.com, miguel.filipe@gmail.com
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49074EA3.2080801@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-10-28 at 10:40 -0700, Zach Brown wrote:
> > Compression is optional and off by default (mount -o compress to enable
> > it).  When enabled, every file is compressed.
> 
> Compression is attempted as files are written when the mount option is
> enabled, right?

Yes, and if the compression doesn't make a given set of pages smaller it
quickly backs off and goes back to writing it straight through.

> 
> There isn't a background scrubber that tries to compress files which are
> already written?

No, but if you mount with compression on and use the single file defrag
ioctl (btrfsctl -d some_file) it'll compress it.

-chris


