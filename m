From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 18 Aug 2011 18:11:11 +0800
Message-ID: <4E4CE53F.3060908@oracle.com>
References: <4E4B2452.9070407@oracle.com> <4E4B88BA.4030603@oracle.com> <2084d6628f888144198ac8450b470b7c.squirrel@www.chrestomanci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: David Pottage <david@electric-spoon.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2084d6628f888144198ac8450b470b7c.squirrel@www.chrestomanci.org>
List-ID: <linux-btrfs.vger.kernel.org>



David,

> I think that you need to be careful not to impose your idea of when to
> take snapshots and how long to keep them onto the design. For example
> why take snapshots every 15 minutes? Why not every 10 or every hour?

  crontab is anyways changeable by the admin, I think we can have that
  flexibility.

> Why treat monthly snapshots as special when it does not fit into most
> working weeks? would weekly be more logical? What about 2 weekly (When
> I worked at Nokia, internal releases where done on Tuesday of each even
> numbered week, so we would have wanted the snapshot taken on that day
> to be retained longer than snapshots taken on other days, or Tuesdays
> in odd numbered weeks.)

  agreed. weekly is more important. (I had that in mind but missed it
  when writing, sorry for that).

> I think a more flexible design would be to allow the user to specify
> (via a config file for each subvolume) a label for each type of snapshot
> and how long to keep snapshots depending on when they are taken. This
> can be done using syntax similar to crontab:

  simple and nice idea. thanks for explaining, will try to get this
  in the initial release.

Cheers, Anand

