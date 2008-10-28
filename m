From: Zach Brown <zach.brown@oracle.com>
Subject: Re: Compressed Filesystem
Date: Tue, 28 Oct 2008 10:40:51 -0700
Message-ID: <49074EA3.2080801@oracle.com>
References: <20081027145401.GB10896@tux64-03>	 <1225208847.6448.172.camel@think.oraclecorp.com>	 <20081028163337.GA8488@tux64-02> <1225215517.6448.176.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org,
	balajirrao@gmail.com, miguel.filipe@gmail.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1225215517.6448.176.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


> Compression is optional and off by default (mount -o compress to enable
> it).  When enabled, every file is compressed.

Compression is attempted as files are written when the mount option is
enabled, right?

There isn't a background scrubber that tries to compress files which are
already written?

- z
