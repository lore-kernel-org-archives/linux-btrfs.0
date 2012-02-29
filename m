From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Wed, 29 Feb 2012 17:14:14 -0500
Message-ID: <20120229221414.GS5054@shiny>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com>
 <20120229025027.GB15383@shiny>
 <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
 <CAE5mzvixYURzdNX3snjjJESUNUBz316YjzDxfZe6-Q2TGBMYww@mail.gmail.com>
 <CAPeorG9E0SDXqoa7VeUASxAbtBf+voQVRgfZ_FtOb3d6nbe-ZQ@mail.gmail.com>
 <20120229135926.GB5054@shiny>
 <CAPeorG9u6Z-Z5QnxAc5QB3ZzrR17+3Y2t-UQFd8v_aqN-rVwTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>, Gurudas Pai <gurudas.pai@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Travis Shivers <ttshivers@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPeorG9u6Z-Z5QnxAc5QB3ZzrR17+3Y2t-UQFd8v_aqN-rVwTA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 29, 2012 at 03:57:19PM -0600, Travis Shivers wrote:
> Here is the output from the commands:
> 
> # ./btrfs-debug-tree -R /dev/sdh
> failed to read /dev/sr0: No medium found
> failed to read /dev/sde: No medium found
> failed to read /dev/sdd: No medium found
> failed to read /dev/sdc: No medium found
> failed to read /dev/sdb: No medium found
> failed to read /dev/sda: No medium found
> parent transid verify failed on 5568194695168 wanted 43477 found 43151

So far all the blocks that have come up look like they are in the extent
allocation tree.  This helps because it is the easiest to recover.

I can also make a patch for you against 3.3-rc that skips reading it
entirely, which should make it possible to copy things off.

But before I do that, could you describe the raid array?  Was it
mirrored or raid10?  What exactly happened when it stopped working?

-chris
