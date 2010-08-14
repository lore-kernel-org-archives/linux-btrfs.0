From: "K. Richard Pixley" <rich@noir.com>
Subject: server goes pathological
Date: Sat, 14 Aug 2010 09:55:46 -0700
Message-ID: <4C66CA92.6030808@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  Ubuntu-10.04, x86, stock.

I'm running into a situation where a server goes pathological.  
Basically, it becomes excruciatingly slow.  I can get things through the 
file system, but a simple file touch can take 6 - 12 hours.

Top shows various btrfs processes hard at work - typically 100% of a 
cpu, (four cpu server), and the machine shows a load of just over 4.  
Some flush-btrfs, some btrfs-transacti, occasional others.

File system is was created with "mkfs.btrfs -m single -d single".

The same, (or a substantially similar), problem has arisen once so far 
on each of three different servers, so I have a good  indication that 
it's not a hardware error.

Aside from rebooting, and rebuilding the file system, is there anything 
I can do to clear this state?

Is there any other information I can provide to help debug either what's 
going on with my server and/or btrfs?

--rich
