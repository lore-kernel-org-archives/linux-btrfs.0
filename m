From: jim owens <jowens@hp.com>
Subject: btrfs with selinux
Date: Wed, 10 Dec 2008 09:33:49 -0500
Message-ID: <493FD34D.8050802@hp.com>
References: <20081209145952.GA30494@tux64-03>	 <1228840516.27601.10.camel@think.oraclecorp.com>	 <200812091126.04044.des@condordes.net>  <493ED385.7000608@hp.com> <1228916750.11900.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228916750.11900.11.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Tue, 2008-12-09 at 15:22 -0500, jim owens wrote:
>> I have been working on changing the xattr code with the first
>> step getting it functioning properly when selinux is enabled
>> so we can see just how costly btrfs xattrs are in actual use.
> 
> Not really on topic, but how are things broken today with selinux?

With selinux enabled you can not create any files on
a btrfs filesystem (as of dec9 git tree with fedora 9),
even as root!

There are 2 things needed to make it work:

1) the /etc/selinux load-into-kernel database must be
    patched to recognize btrfs has xattrs. One of our
    security people, Paul Moore, has submitted it to
    the upstream refpolicy.  But it won't be merged
    until I finish my testing.

After the database is patched, the dec9 git tree
will allow file create on btrfs... but the selinux
xattrs are not set.  Thus "cp -a" will copy the
files but all "selinux context" values are wrong.

2) I have btrfs patches to interface correctly with
    the LSM so we save the selinux context. I'll be
    sending them up as soon as I have finished testing.

jim

P.S. sane people just disable selinux on install :)
