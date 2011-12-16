From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Fri, 16 Dec 2011 20:53:58 +0100
Message-ID: <201112162053.58332.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112161854.46717.Martin@lichtvoll.de> <4906354.Rn8tlOeHyD@venice> (sfid-20111216_202835_293409_FE477894)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@inwind.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4906354.Rn8tlOeHyD@venice>
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 16. Dezember 2011 schrieb Goffredo Baroncelli:
> On Friday, 16 December, 2011 18:54:46 you wrote:
> > Am Freitag, 16. Dezember 2011 schrieb Martin Steigerwald:
> > > Its not critical for me to fix these issues (soon), but I am
> > > curious whether its possible to get the filesystem speedier by
> > > some maintenance.
> > 
> > Maybe after it is clear why it is so slow in the first place ;).
> 
> I had the same experience. apt-get upgrade was a frustrating
> experience!
> 
> IIRC the copy-on-write file-system in order to have good performance
> have to merge the write requests most as possible.
> 
> Instead apt-get makes a lot of sync calls which don't allow btrfs to
> merge the write requests. This explains why btrfs is slow in this
> case.

Ah, I see. AFAIR there have been added an option for apt/aptitude to omit 
the fsync itself.

Hmmm, a co-worker had the issue of Iceweasel with lots of tabs open being 
slow and I suspected that high fsync() usage of SQLite3 databases for 
bookmarks and stuff might be the culprit. The issue went away for him after 
switching to Ext4.

> I found a solution, but requires a bit of setup.
> 
> The idea is to avoid do perform sync during the package installation.
> In order to avoid data loss in case of failure, I create a snapshot
> before the upgrading. If something goes wrong (i.e. a power failure) I
> rebooot the system from the snapshot. If the installation finish
> without problem, I flush all the data to the disk and remove the
> snapshot.
> 
> For the detail, see a my old post titled "[RFC] aptitude & BTRFS slow"
> (2011-10-19)

Sounds more like a workaround to me than a solution.

I feel reluctant about working around what seems to be a filesystem 
limitation. (A filesystem should not break, i.e. slow down an existing user 
space application beyond a certain limit I think).

I wonder whether it might be a good idea to have nodatacow for /:

nodatacow - Do not copy-on-write data. datacow is used to ensure the user 
either has access to the old version of a file, or to the newer version of 
the file. datacow makes sure we never have partially updated files written 
to disk. nodatacow gives slight performance boost by directly overwriting 
data (like ext[234]), at the expense of potentially getting partially 
updated files on system failures. Performance gain is usually < 5% unless 
the workload is random writes to large database files, where the difference 
can become very large 

(see https://btrfs.wiki.kernel.org/articles/g/e/t/Getting_started.html)

Then writing of files would be back to the Ext3/4 way of doing it.

What do you think?

PS: I am not sure whether its just aptitude. I have occassional audio 
stalls even while not upgrading the system. But then that might be 
pulseaudio although sound playback threads are running with realtime 
priority.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
