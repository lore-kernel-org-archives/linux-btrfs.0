From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: Btrfs slowdown
Date: Mon, 25 Jul 2011 15:37:51 +0100
Message-ID: <j0jv3v$fa6$1@dough.gmane.org>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christian Brunner wrote:

> we are running a ceph cluster with btrfs as it's base filesystem
> (kernel 3.0). At the beginning everything worked very well, but after
> a few days (2-3) things are getting very slow.

We get quite a slowdown over time, doing rsyncs to different snapshots. 
Btrfs seems to go from using several threads in parallel btrfs-endio-0,1,2, 
shown in top, to just using a single thread btrfs-delalloc.

Jeremy

