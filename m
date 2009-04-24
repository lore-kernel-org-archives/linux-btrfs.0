From: Chris Mason <chris.mason@oracle.com>
Subject: Re: LVM vs btrfs as a "volume manager" for SANs
Date: Fri, 24 Apr 2009 08:38:38 -0400
Message-ID: <1240576718.29896.2.camel@think.oraclecorp.com>
References: <49EF6DF7.9020406@wpkg.org>
	 <1240512313.28015.14.camel@think.oraclecorp.com>
	 <49F0FAEA.2020904@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F0FAEA.2020904@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-04-24 at 01:34 +0200, Tomasz Chmielewski wrote:
> Chris Mason schrieb:
> 
> >> However, with btrfs, I'm not sure about:
> >>
> >> - what happens if SAN machine crashes while the iSCSI file images were 
> >> being written to; with LVM and its block devices, I'm somehow more 
> >> confident it wouldn't make more data loss than necessary
> > 
> > If iscsi is writing with O_DIRECT|O_SYNC it should work.
> 
> What if it doesn't?
> 

Writes would go to the page cache only (not O_DIRECT) and the metadata
wouldn't get flushed with each write (not O_SYNC).

-chris


