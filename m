From: Jim Maloney <jim@webstarts.com>
Subject: btrfs over nfs
Date: Mon, 22 Aug 2011 17:07:45 -0400
Message-ID: <CAGFoeJ8J4f2_r=bdWapr0CM+Oq+aSJ78-E4D2zP5atHXdovoFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have been experimenting exporting btrfs subvolumes over nfs.  Main
subvolume is filesys1 mounted at /filesys1.  Below this is subvolume
base, user1 is in base and documents is in user1.   documents is
mounted at /documents.  /etc/exports is:
/filesys1/base/user1    172.16.0.0/24(rw,no_acl,no_root_squash,fsid=0)
/filesys1/user1-snapshot        172.16.0.0/24(rw,no_acl,no_root_squash,fsid=0)
/documents      172.16.0.0/24(rw,no_acl,no_root_squash,fsid=0)

On the client machine I mount user1 as /mnt/user and all data from
user is present.
I can also umount /mnt/usr and mount /documents as /mnt/documents and
all data is present.
However, if I mount user1 as /mnt/user and then mount /documents as
/mnt/documents
the data from the last subvolume mounted shows in both mounts.  Mount
also shows:
172.16.0.28:/documents/ on /mnt/user type nfs
(rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=172.16.0.28,mountvers=3,mountport=892,mountproto=udp,local_lock=none,addr=172.16.0.28)
172.16.0.28:/documents/ on /mnt/documents type nfs
(rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=172.16.0.28,mountvers=3,mountport=892,mountproto=udp,local_lock=none,addr=172.16.0.28)

The initial mount of user1 on /mnt/user showed correctly in mount.
Mount changes when I add the mount for /documents.
I don't know how to troubleshoot this.  I am happy to provide any info
which can help.
Btrfs is currently on a centOS6 machine running kernel 3.0.1 with
btrfs-progs from git unstable.
NFS is v3 on both server and client and the client is Fedora 15 kernel
2.6.40-4.fc15.x86_64
Thanks
Jim Maloney


--
Jim Maloney

email - jim@webstarts.com
