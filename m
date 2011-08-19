From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Fri, 19 Aug 2011 17:58:51 +0800
Message-ID: <4E4E33DB.6010209@oracle.com>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4BD272.8000704@uvm.edu> <20110817145509.GA23804@hendrix.borisch.local> <4E4C7BCD.6090004@oracle.com> <4E4CB4D9.4060509@gmail.com> <4E4CBF43.60207@uvm.edu> <4E4CFB53.1020208@uvm.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Andrew Guertin <andrew.guertin@uvm.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CFB53.1020208@uvm.edu>
List-ID: <linux-btrfs.vger.kernel.org>


Andrew,

  Facing some challenges to test this. If you have a chance to test
  it again, the following output will be interesting to observe.
    iostat -ctx -p sda 3 >  /tmp/iostat.out

  Also note your system time when this problem occurs, (iostat has time
  stamp, I wish see the waitQ and activeQ at that time, hopefully
  captured in the file /tmp/iostat.out above).

  We need more clarity on the test-case which can reproduce this issue.
  As I know you are writing into the btrfs. However is that a large
  number of small files (you are creating new files) OR you are writing
  a few large new files ?

  If there is any script to test this that will make understanding
  a lot easier.

  PS: Does anybody know Solaris lockstat(1M) equivalent in Linux ?

Thanks, Anand
