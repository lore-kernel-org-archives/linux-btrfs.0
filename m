From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] btrfs send and receive
Date: Wed, 03 Aug 2011 20:52:48 +0200
Message-ID: <23039341.GAZYc0s4Vv@venice>
References: <4E369A80.9030307@jan-o-sch.net> <4E36F5B8.5090803@libero.it> <4E37C6CB.1030201@jan-o-sch.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E37C6CB.1030201@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 02 August, 2011 11:43:39 you wrote:
> On 01.08.2011 20:51, Goffredo Baroncelli wrote:
[...]
> > 1) If we are interested to transport only the file
> > type/contents/timestamps/acls/owners/permissions, that could be obtained
> > with a combination of "find-new" (with some extensions [1]) and an
> > user-space tool. No extension to BTRFS are needed.
> 
> Right. This is not what I'm after.
> 
> > 1.1) as above plus preserve the inode number.
> > 
> > 2) If we want to have also to conserver the COW relation (between
> > snapshots/subvolumes and  files), I think that we need some help from
> > the kernel side to be able to injecting these information in the
> > destination btrfs filesystem.
> 
> I'd rather gather those information (possibly with help from the kernel)
> when generating the stream. I realized that I should have used some
> examples in my original mail. What I have in mind (as briefly described
> in my section 5.D) is the following:
> 
> To not make it overly complex, let's assume snapshots are read only for
> a moment.
> 
> We have a subvolume /home with one snapshot /home/snap1. When we want to
> send the whole subvolume we could do the following (if you read section
> 5 assume --minimal was the default):
> 
> btrfs subvol snapshot /home send-test
> btrfs send /home send-test > /tmp/stream
> 
> Algorithm: First pick all files from the oldest snapshot (snap1) and put
> them into the stream. Then, there is a block of meta information saying
> "snap1 complete". The next in the stream are the diffs between snap1 and
> send-test (reflecting the current state of /home), again with an end-marker.
> 
> Let's assume we have a freshly created empty /backup subvolume. To
> receive our changes, we'd call the following:
> 
> btrfs receive /backup < /tmp/stream
> 
> Algorithm: Use data from the stream to create files to /backup/home.
> Once we reach the meta information mentioned above, we create a snapshot
> of /backup/home in /backup/home/snap1. Then we go on receiving the diffs
> in the stream to /backup/home and create a snapshot send-test.

Basically we need a tool to evaluate the difference (in terms of metadata and 
file content) between two snapshot which have an ancestor in common. This is a 
typical problem of the VCS software. 

On the basis of that we can generate a stream, which may be a diff between two 
snapshot or a full subvolume (no diff).

On the receiver side in case of diff there is the necessity to check if both 
the side have the "old" snapshot, and if these snapshots are aligned. I think 
that tracking the subvolume-id and the generation-no we can check this easily.

> 
> > Moreover we need to cope all the possible errors due to the fact that
> > the snapshot/subvolume are out-sync between the source fs and the
> > destination fs: what about if we want to transport a snapshot to an
> > another filesystem where the snapshotted subvolume (previously
> > successful transported) was removed or changed ? How we can check if a
> > snapshot/subvolume was changed ?
> 
> Continuing the above example, lets assume we have a /backup subvolume
> that did receive a /backup/home earlier. Receiving a full stream (as
> generated above) would fail, then. You could remove the subvolume and
> receive the new full stream, if you like.
> 
> Now let's assume we have /home with snap1, send-test, snap2 and snap3.
> On the backup side, we have /backup/home with snap1 and send-test.
> 
> We make another snapshot and generate an incremental stream on the sender:
> 
> btrfs subvol snapshot /home incr-test
> btrfs send /home send-test incr-test
> 
> The stream contains the information that it's based on the snapshot
> send-test (maybe by uuid rather than name). When we receive the stream,
> we first check if the destination file system /backup/home has that
> send-test snapshot.
> 
> a) If it does and there are no diffs between /backup/home and
>    /backup/home/send-test, noone modified the destination => receive
> 
> b) If it does and there are diffs between the two, receive should fail
>    unless --force is specified, which would eliminate all the changes
>    made in /backup/home so that it's rolled back to send-test.
> 
> c) If if does not, receive just fails.
> 
> Although the current algorithm breaks when we release the read-only
> precondition, I'm certain we can turn these fuzzy ideas into an actually
> working solution
> 
> Thanks,
> -Jan
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
