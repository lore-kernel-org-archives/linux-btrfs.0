From: Chris Mason <chris.mason@oracle.com>
Subject: Updates pushed out
Date: Tue, 06 Jan 2009 09:25:42 -0500
Message-ID: <1231251942.4290.153.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I'm pushing out fixes for most of the issues brought up in code review
for merging into mainline.  Soon the unstable trees will be updated to
2.6.28

One of the commits is quite large, fixing almost all of the
checkpatch.pl warnings and errors.  Most of them were one of these 3:

while(x) -> while (x)
printk() -> printk(KERN_FOO)

printk(... %Lu, some_u64) -> printk(... %llu, (unsigned long
long)some_u64)

There were other bits and pieces, but please run your patches through
checkpatch.pl before you send them from now on.

-chris


