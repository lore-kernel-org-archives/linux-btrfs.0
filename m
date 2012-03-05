From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Mon, 05 Mar 2012 14:51:10 +0800
Message-ID: <4F54625E.6040003@oracle.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>	<1330484376-16178-2-git-send-email-anand.jain@oracle.com> <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


>(notably the direct modification of
> crontab files, which is considered to be an internal detail if I
> understand correctly, and I'm fairly certain is broken as written),

  I did came across that point of view however, using crontab cli in the
  program wasn't convincing either, (library call would have been better).
  any other better ways to manage cron entries ?

> and how it writes to its own config file.

  Hm. not sure if I understand this. you mean having binary file not
  a good idea ?

> Neither has any business in btrfs-progs in my somewhat irrelevant opinion. :p

  A separate autosnap script (outside btrfs-progs) was in the original
  plan. But having an integrated solution plus without having to manage
  a new script will certainly help sysadmins IMO. (But if there is no
  strong interest I would separate it out).

> It also does not appear to handle mountpoints in its directory walk,
> which will cause grief if snapshotting /

  Not sure if I understand this correctly. I manage with fsid.
  But, as of now autosnap isn't designed to handle root OR the mount point.
  (this is covered in the caveat section in the btrfs autosnap wiki).
  We still need more work from the btrfs kernel if we are taking the
  snapshot of the mountpoint (as in the wiki FAQ as well).
  
> There doesn't appear to be any reason for the scratch file to exist at
> all (one can build up the hash while reading the directories), and
> keeping a scratch file in /etc/ is poor practice in the first place
> (that's what /tmp and/or /var/run is for).

  Right. sorry, my mistake I didn't change back to tmp location after debugging.

>  It's also a lot of io to
> stat every file in the subvolume every time you make a snapshot, and
> I'm not convinced that the walk is actually correctly implemented:
> what stops an autosnap of / from including all of /proc and /sys in
> the hash?

  Autosnap are for the subvols excluding the mount-point itself.
  Yes we need to look this part when we support the root / mount-point.
  (This is mentioned the caveat section in autosnap wiki, however will
  put more emphasis, thanks for highlighting the real problem).

> Perhaps all that is unnecessary:  rather than doing the walk, why not
> make use of btrfs subvolume find-new (or rather, the syscalls it
> uses)?
>
> Prior to making a new snapshot, grab the (stored) transid of the
> previous snapshot, and check if any files have been modified in the
> source since that transid:  btrfs sub find "${source}"
> "${previous_transid}".  If nothing is returned, then you don't have to
> bother making the snapshot at all, otherwise after making the
> snapshot, grab the transid via btrfs sub find "${new_snapshot}" -1,
> and store it some place (even a dot file in the root of the snapshot
> would work).
>
> This avoids creating and immediately deleting a snapshot every time
> nothing has changed, completely avoids the need to stat the entire
> subvolume every time, and removes the dependency on the crypto libs.
  
  right. Hashing isn't (performance) scalable, and not a good idea to
  fill SSDs with non-application-data at each autosnap. Relaying on
  transaction id will help when transactions are committed. Will get
  this coded this way.

thanks, Anand

