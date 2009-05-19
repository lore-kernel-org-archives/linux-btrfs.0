From: jim owens <jowens@hp.com>
Subject: Re: extended acls..
Date: Tue, 19 May 2009 15:08:22 -0400
Message-ID: <4A1303A6.1050407@hp.com>
References: <42ab06770905190950x5077edb0s3c55bd1c39ebeebe@mail.gmail.com> <20090519180608.GC7472@dhcp231-156.rdu.redhat.com> <20090519182110.GA15389@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Sriram Ramkrishna <sriram.ramkrishna@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090519182110.GA15389@think>
List-ID: <linux-btrfs.vger.kernel.org>

I would suggest another step is more important than starting
with fsdev.  You need to talk to the security people.

There is no point in storing and fetching ACLs if there
is no mechanism to operate on them.

filesystems don't create security policies.

jim
