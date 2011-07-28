From: Sage Weil <sage@newdream.net>
Subject: Re: Btrfs slowdown
Date: Thu, 28 Jul 2011 09:01:19 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1107280853590.13306@cobra.newdream.net>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
 <1311623446-sup-8105@shiny> <CAO47_--KOyMdS-OP06cLpD+qTQ+gqGcw_DCPUrLOeypt5j_G4g@mail.gmail.com>
 <CALFpzo4aNPmypyHXbK9YnxuQxNcDXv7wf+KPxakkcJVuZN5eaw@mail.gmail.com>
 <CAO47_-9r86Bbfzh7VpmUCP8BQgE4ciPAgDapJmxMsoTWz4PE3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Marcus Sorensen <shadowsor@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel <ceph-devel@vger.kernel.org>
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9r86Bbfzh7VpmUCP8BQgE4ciPAgDapJmxMsoTWz4PE3w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 28 Jul 2011, Christian Brunner wrote:
> When I look at the latencytop results, there is a high latency when
> calling "btrfs_commit_transaction_async". Isn't "async" supposed to
> return immediately?

It depends.  That function has to block until the commit has started 
before returning in the case where it creates a new btrfs root (i.e., 
snapshot creation).  Otherwise a subsequent operation (after the ioctl 
returns) can sneak in before the snapshot is taken.  (IIRC there was also 
another problem with keeping internal structures consistent, tho I'm 
forgetting the details.)  And there are a bunch of things 
btrfs_commit_transaction() does before setting blocked = 1 that can be 
slow.  There is a fair bit of transaction commit optimization work that 
should eventually be done here that we sadly haven't had the resources to 
look at yet.

sage
