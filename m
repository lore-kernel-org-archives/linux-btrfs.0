Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:40282 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab2F0Nr2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:47:28 -0400
Date: Wed, 27 Jun 2012 09:47:24 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chester <somethingsome2000@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs volume suddenly becomes read-only
Message-ID: <20120627134723.GB2819@localhost.localdomain>
References: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
 <CAAE6i0jcfJvBq_JJhO-DVWqBrtEJe1nA7t8k-fqF0BtQY15N4w@mail.gmail.com>
 <CAAE6i0hxv2t0-df+JLtCTC7k8VKTuH-DkUQ7saOSGWSKEV7C2Q@mail.gmail.com>
 <CAAE6i0i7etUgKgGEAzDR6BSruz4AWhaw-0_zvHxwqDAQnyBQ3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAAE6i0i7etUgKgGEAzDR6BSruz4AWhaw-0_zvHxwqDAQnyBQ3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 10:24:56PM -0600, Chester wrote:
> Problem still occurs.. With just a bittorrent client (downloading) +
> chrome running.
> 
> This could also be related but, last night, I triggered a btrfs
> balance.. I'm not too sure whether the balance finished or not,
> because when I took a look at it this morning, it said "no file or
> directory" and told me to check dmesg for messages. I did check, and I
> saw the usual bunch of "moving block group" and "xxxx extents found"
> messages that come from balances.

Can you run btrfsck on this volume?  There may be some extent tree corruption
and that's why its freaking out.  If it comes back clean then I will come up
with a debug patch for you.  Thanks,

Josef
