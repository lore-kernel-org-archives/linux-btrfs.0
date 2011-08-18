From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 10:41:17 +0800
Message-ID: <4E4C7BCD.6090004@oracle.com>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Andrew Guertin <andrew.guertin@uvm.edu>,
	Michael Cronenworth <mike@cchtml.com>,
	linux-btrfs@vger.kernel.org
To: Dave <dave@thekilempire.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817145509.GA23804@hendrix.borisch.local>
List-ID: <linux-btrfs.vger.kernel.org>


Dave,

  good to have a test case on the 3.0 kernel.  do you have btrfs as
  root fs ? and
  can you show how are you using the btrfs mainly I would need
  'btrfs fi show' let me try if I can reproduce.

Thanks, Anand


> I've been simply living with this issue.  I can reproduce it by rsyncing very
> large files to a btrfs volume.  My entire desktop will freeze for up to three
> minutes and no amount of nice/ionice can temper this.
>
> Once I've finished the rsync certain apps will periodically hang (Firefox in
> particular).  This behavior goes away after a reboot.
>
> I'm running kernel version 3.0.
