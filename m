From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: btrfs and swap files on SSD's =?UTF-8?Q?=3F?=
Date: Tue, 20 Jan 2009 09:35:02 -0700
Message-ID: <f45c907a12e473689f0061d68c4e0749@smtp.arbitraryconstant.com>
References: <200901171110.22803.chris@csamuel.org> <1232382162.6521.108.camel@think.oraclecorp.com> <4975AA6C.8@schleiser.de> <1232456536.15042.0.camel@think.oraclecorp.com> <3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com> <1232461902.15042.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Dmitri Nikulin <dnikulin@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232461902.15042.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> The second is an implementation detail of the linux swap file code.  It
> expects filesystems don't move blocks around, and takes a mapping of the
> blocks in the FS once.
> 
> This doesn't work with btrfs because we do move blocks around all the
> time.

That's interesting. I have a few questions:

-Is creating a loopback device from the file any different, or does that
lead to the same problems?

-Would mounting a filesystem image via loopback device cause similar
problems?

-Would this be viable if using a dedicated nodatacow subvolume, or is that
still too risky because of the odd case where you do cow?

-Does online defragmentation hurt this as well?

Cheers,

-Anthony

