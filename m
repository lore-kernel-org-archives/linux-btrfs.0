From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 12:29:02 +0000
Message-ID: <4D25B58E.2080208@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <ig4bur$mns$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ig4bur$mns$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Simon Farnsworth wrote:

> The basic idea is to use fanotify/inotify (whichever of the notification 
> systems works for this) to track which inodes have been written to. It can 
> then mmap() the changed data (before it's been dropped from RAM) and do the 
> same process as an offline dedupe (hash, check for matches, call dedupe 
> extent ioctl). If you've got enough CPU (maybe running with realtime privs), 
> you should be able to do this before writes actually hit the disk.

I'm not convinced that racing against the disk write is the way forward 
here.

As for having enough CPU to do this, a lot of modern CPUs (ARM, SPARC, 
Xeon) actually have hardware crypto acceleration/offload, so calculating 
checksums is fast and cheap.

Gordan
