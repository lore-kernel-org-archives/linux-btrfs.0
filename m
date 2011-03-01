From: Xin Zhong <thierryzhong@hotmail.com>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Wed, 2 Mar 2011 00:36:18 +0800
Message-ID: <BAY156-w43472A651462DCADA1F9FAD2C10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi, Mitch
I think you can config ftrace to just trace function calls of btrfs.ko which will save a lot of trace buffer space. See below command:
#echo ':mod:btrfs' > /sys/kernel/debug/tracing/set_ftrace_filterAnd please send out the full ftrace log again.

Another helpful information might be the strace log of the wmldbcreate process. It will show us the io pattern of this command.
Thanks a lot for your help!
  		 	   		  
