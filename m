From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How Snapshots Inter-relate?
Date: Fri, 22 Apr 2011 22:30:05 +0700
Message-ID: <BANLkTinkYrzO8xA4B32=xFDP7zmWJ-zaHQ@mail.gmail.com>
References: <201104211017.52341.CACook@quantum-sci.com>
	<1303411647.25281.2.camel@ayu>
	<201104220803.20552.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201104220803.20552.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 22, 2011 at 10:03 PM,  <CACook@quantum-sci.com> wrote:
> Would it be good practice to say, once a year, do a completely new fresh snapshot?

There's no such thing as "new fresh snapshot".

You can create a new, empty subvolume.
Or you can create snapshot of existing root/subvolume, which once
created, behaves just like another subvolume (with the exception that
it contains identical content to the origin root/subvolume).
Or you can create snapshot of a snapshot (which, again, is just
another subvolume with identical content) so in practice there will be
no difference between the first snapshot and the second snapshot.

So if by "new fresh snapshot" you mean "creating a snapshot of
root/subvolume at that time", then you can do it as often as you need.
But if by "new fresh snapshot" you mean something like full backup in
traditional tape backup, then like Calvin said every snapshot is
already independent, so in a way it's a "full backup".

Of course if you're using it for backup purposes then it's usually
best to have a copy elsewhere (not on the same
disk/server/datacenter), but that's beyond the scope of this list.

-- 
Fajar
