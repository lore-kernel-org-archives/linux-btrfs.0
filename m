Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35226 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab2IXPu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 11:50:26 -0400
Date: Mon, 24 Sep 2012 17:50:15 +0200
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, dave@jikos.cz,
        Liu Bo <bo.li.liu@oracle.com>
Subject: Re: enquiry about autodefrag option
Message-ID: <20120924155015.GK14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50570652.4060200@gmail.com>
 <5059AC5E.1030003@gmail.com>
 <5059D2D3.3050303@oracle.com>
 <505A5715.9060309@gmail.com>
 <20120920115111.GJ17430@twin.jikos.cz>
 <505B84AD.7010808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505B84AD.7010808@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 05:03:41AM +0800, ching wrote:
> AFAIK, the autodefrag will read related extents and mark them dirty,
> io niceness should be applicable to the read operation

I was hesitant to believe that, but tried it and it's right:

$ dd if=/dev/zero bs=4k count=1 seek=15 of=file
$ dd if=/dev/zero bs=4k count=1 seek=13 of=file conv=notrunc
$ dd if=/dev/zero bs=4k count=1 seek=14 of=file conv=notrunc

Filesystem type is: 9123683e
File size of file is 65536 (16 blocks, blocksize 4096)
 ext logical physical expected length flags
   0      13     1027               1
   1      14     1050     1027      1
   2      15     1025     1050      1 eof
file: 4 extents found

remount with autodefrag:

$ dd if=/dev/zero bs=4k count=1 seek=16 of=file conv=notrunc

Filesystem type is: 9123683e
File size of file is 69632 (17 blocks, blocksize 4096)
 ext logical physical expected length flags
   0      13     1033               4 eof
file: 2 extents found


david
