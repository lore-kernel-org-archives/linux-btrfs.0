From: "Heinz-Josef Claes" <hjclaes@web.de>
Subject: Re: Content based storage
Date: Wed, 17 Mar 2010 09:48:18 +0100
Message-ID: <201003170948.18819.hjclaes@web.de>
References: <hnnijd$jol$1@dough.gmane.org> <201003170145.10615.hka@qbs.com.pl> <hnq3pd$801$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <hnq3pd$801$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just want to add one correction to your thoughts:

Storage is not cheap if you think about enterprise storage on a SAN, 
replicated to another data centre. Using dedup on the storage boxes leads to 
performance issues and other problems - only NetApp is offering this at the 
moment and it's not heavily used (because of the issues).

So I think it would be a big advantage for professional use to have dedup 
build into the filesystem - processors are faster and faster today and not the 
cost drivers any more. I do not think it's a problem to "spend" on core of a 2 
socket box with 12 cores for this purpose.
Storage is cost intensive:
- SAN boxes are expensive
- RAID5 in two locations is expensive
- FC lines between locations is expensive (depeding very much on where you 
are).

Naturally, you would not use this feature for all kind of use cases (eg. 
heavily used database), but I think there is enough need.

my 2 cents,
Heinz-Josef Claes

On Wednesday 17 March 2010 09:27:15 you wrote:
> On 17/03/2010 01:45, Hubert Kario wrote:
> > On Tuesday 16 March 2010 10:21:43 David Brown wrote:
> >> Hi,
> >> 
> >> I was wondering if there has been any thought or progress in
> >> content-based storage for btrfs beyond the suggestion in the "Project
> >> ideas" wiki page?
> >> 
> >> The basic idea, as I understand it, is that a longer data extent
> >> checksum is used (long enough to make collisions unrealistic), and merge
> >> data extents with the same checksums.  The result is that "cp foo bar"
> >> will have pretty much the same effect as "cp --reflink foo bar" - the
> >> two copies will share COW data extents - as long as they remain the
> >> same, they will share the disk space.  But you can still access each
> >> file independently, unlike with a traditional hard link.
> >> 
> >> I can see at least three cases where this could be a big win - I'm sure
> >> there are more.
> >> 
> >> Developers often have multiple copies of source code trees as branches,
> >> snapshots, etc.  For larger projects (I have multiple "buildroot" trees
> >> for one project) this can take a lot of space.  Content-based storage
> >> would give the space efficiency of hard links with the independence of
> >> straight copies.  Using "cp --reflink" would help for the initial
> >> snapshot or branch, of course, but it could not help after the copy.
> >> 
> >> On servers using lightweight virtual servers such as OpenVZ, you have
> >> multiple "root" file systems each with their own copy of "/usr", etc.
> >> With OpenVZ, all the virtual roots are part of the host's file system
> >> (i.e., not hidden within virtual disks), so content-based storage could
> >> merge these, making them very much more efficient.  Because each of
> >> these virtual roots can be updated independently, it is not possible to
> >> use "cp --reflink" to keep them merged.
> >> 
> >> For backup systems, you will often have multiple copies of the same
> >> files.  A common scheme is to use rsync and "cp -al" to make hard-linked
> >> (and therefore space-efficient) snapshots of the trees.  But sometimes
> >> these things get out of synchronisation - perhaps your remote rsync dies
> >> halfway, and you end up with multiple independent copies of the same
> >> files.  Content-based storage can then re-merge these files.
> >> 
> >> 
> >> I would imagine that content-based storage will sometimes be a
> >> performance win, sometimes a loss.  It would be a win when merging
> >> results in better use of the file system cache - OpenVZ virtual serving
> >> would be an example where you would be using multiple copies of the same
> >> file at the same time.  For other uses, such as backups, there would be
> >> no performance gain since you seldom (hopefully!) read the backup files.
> >> 
> >>    But in that situation, speed is not a major issue.
> >> 
> >> mvh.,
> >> 
> >> David
> >> 
> >  From what I could read, content based storage is supposed to be in-line
> > 
> > deduplication, there are already plans to do (probably) a userland daemon
> > traversing the FS and merging indentical extents -- giving you
> > post-process deduplication.
> > 
> > For a rather heavy used host (such as a VM host) you'd probably want to
> > use post-process dedup -- as the daemon can be easly stopped or be given
> > lower priority. In line dedup is quite CPU intensive.
> > 
> > In line dedup is very nice for backup though -- you don't need the
> > temporary storage before the (mostly unchanged) data is deduplicated.
> 
> I think post-process deduplication is the way to go here, using a
> userspace daemon.  It's the most flexible solution.  As you say, inline
> dedup could be nice in some cases, such as for backups, since the cpu
> time cost is not an issue there.  However, in a typical backup
> situation, the new files are often written fairly slowly (for remote
> backups).  Even for local backups, there is generally not that much
> /new/ data, since you normally use some sort of incremental backup
> scheme (such as rsync, combined with cp -al or cp --reflink).  Thus it
> should be fine to copy over the data, then de-dup it later or in the
> background.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
