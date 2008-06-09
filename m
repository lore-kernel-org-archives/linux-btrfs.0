From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Bug report, OOPs on weird conditions.. device under mdadm
	raid1 failed...
Date: Mon, 09 Jun 2008 09:41:24 -0400
Message-ID: <1213018884.10187.3.camel@think.oraclecorp.com>
References: <f058a9c30806031701w633a199dq5cc56b07df1b19f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30806031701w633a199dq5cc56b07df1b19f2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-06-04 at 01:01 +0100, Miguel Sousa Filipe wrote:
> Hello,
> 
> I have a Kernel Bug report.
> I must warn that this happened on bad hardware.. one disc of a md
> raid1 started to fault..
> my dmesg if full of these:
> 

Something rather strange is happening here, but once Btrfs oopses it is
hard to blame MD for anything that happens.  Have you reproduced this at
all?

-chris


