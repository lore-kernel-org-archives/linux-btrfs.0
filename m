From: Daniel Phillips <phillips@phunq.net>
Subject: Re: snapshot merging?
Date: Tue, 23 Sep 2008 20:34:21 -0700
Message-ID: <200809232034.21750.phillips@phunq.net>
References: <48D63C8E.2060802@wpkg.org> <48D657DB.7050601@oracle.com> <48D65ACD.7030907@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Zheng Yan <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48D65ACD.7030907@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 21 September 2008 07:31, Tomasz Chmielewski wrote:
> > Writeable snapshot has been available in btrfs for a long time.
> 
> Writeable snapshots and snapshot merging are two different things.

I think what Mikulas really means by "snapshot merging" is what we call
"revert to snapshot" in ddsnap (google Zumastor ddsnap).  The latter is
more appropriate terminology IMHO.  For a snapshotted volume, this just
requires copying any blocks that belong to the snapshot and not the
origin back to the origin.  Similarly, one could revert any snapshot
"back" (quotes because there is not necessarily any relationship in
time) to any other.  For a filesystem it will not be nearly so simple,
because at best only part of the job can be done at the physical block
level.

Regards,

Daniel
