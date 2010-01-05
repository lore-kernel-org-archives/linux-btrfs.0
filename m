From: Piavlo <piavka@cs.bgu.ac.il>
Subject: snapshot/subvolume removal
Date: Tue, 05 Jan 2010 23:18:19 +0200
Message-ID: <4B43AC9B.5030109@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Hi,

Does btrfs support snapshot or/and subvolume removal ?
If yes how, since I could not find the commands to do that?
If not is there any estimation when this feature will be available?

Is there a tool to list the existing subvolumes/snapshots?

It looks like the snapshots can overridden by subvolumes, see below:

shell>  btrfsctl  -s rsync-snap rsync
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
shell>  btrfsctl  -S rsync-snap rsync
operation complete
Btrfs v0.19-4-gab8fb4c-dirty
shell> btrfsctl  -s rsync-snap rsync
ioctl:: File exists
shell>

Is that expected?
What happens to the snapshot  then it is overridden by subvolume?
It does not seem reasonable that snapshot can be converted into 
subvolume, since newly created subvolume
holds no data ,while the snapshot is a snapshot of other previously
existing subvolume and holds data.
So is snapshots simply destroyed prior to subvolume creation, in the
above scenario?

 Thanks
 Alex

