From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: btrfs frozen solid with postgresql dbs
Date: Sat, 16 Apr 2011 10:24:11 -0400
Message-ID: <87ei52uvec.fsf@gmail.com>
References: <BANLkTimFNpi_AF_n6-=gOp1N1U12QturyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "krzf83\@gmail.com" <krzf83@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimFNpi_AF_n6-=gOp1N1U12QturyA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 16 Apr 2011 15:07:50 +0200, "krzf83@gmail.com " <krzf83@gmail.com> wrote:
> kernel: 2.6.37.6
> 
> At least twice I've experienced problems when using btrfs with ssd for
> postgresql db storage. Server gets frozen, i even can't kill it using
> kill -9, I cant chown postgresql db dir (it never gets done). If I
> initiate copy operation of postgresql db dir to another partition
> (without actually switching to using it) everything starts to work
> fine for some time...
> 
You may want to try Sysrq-W to see where the server is stuck.

Just a thought...

 - Ben
