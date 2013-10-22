Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3JVRWu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 13:22:50 -0400
Date: Tue, 22 Oct 2013 18:22:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Phil Davis <pmdhazy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send 'leaks' open files
Message-ID: <20131022172249.GV13318@ZenIV.linux.org.uk>
References: <CAERquQ78pOig3oQoom2e0Jcsv1i3-_8ET0ewAWUUo+nt2vk4Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAERquQ78pOig3oQoom2e0Jcsv1i3-_8ET0ewAWUUo+nt2vk4Mg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 20, 2013 at 11:33:56AM +0100, Phil Davis wrote:

> The reason I think btrfs send is leaking open files is if you watch
> /proc/sys/fs/file-nr you see the
> number of open files increasing  but if you kill the btrfs send
> process then the open
> files count reduces back down.  In fact suspending the process also
> reduces the open file count but
> resuming it then makes the count start increasing again.

What does lsof show while you are running that?  AFAICS, btrfs_ioctl_send()
should be neutral wrt file references - we do fget() on entry and
fput() of the result on exit, with nothing else looking relevant in
sight...  OTOH, btrfs-progs number of calls of that ioctl() seems to
be bounded by the length of argument list.  So the interesting questions
are
	a) how many btrfs send instances are running at the time?
	b) what do their arg lists look like?
	c) who (if anyone) has all those opened files in their descriptor
tables?

BTW, looking at do_send()...
        if (g_verbose > 0)
                fprintf(stderr, "joining genl thread\n");

        close(pipefd[1]);
        pipefd[1] = 0;

        ret = pthread_join(t_read, &t_err);
...
        if (subvol_fd != -1)
                close(subvol_fd);
        if (pipefd[0] != -1)
                close(pipefd[0]);
        if (pipefd[1] != -1)
                close(pipefd[1]);

That pipefd[1] = 0; looks bogus; it doesn't look like it could result in
what you are seeing, but unless I'm misreading that code it ought to be
pipefd[1] = -1...
