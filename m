From: Gregory L Shomo <greg@techsquare.com>
Subject: parent transid troubles
Date: Tue, 19 Apr 2011 15:08:13 -0400
Message-ID: <sa2hb9u9i02.fsf@techsquare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list-

Under heavy load (i/o), one of our fileservers lost two drives
in a raid6 configuration. After the drives were synchronized,
we can no longer mount the multiple-device btrfs filesystem
due to (at least) parent transid verification.

btrfsck built from git commit 1b444cd2e6ab8dcafdd47dbaeaae369dd1517c17
runs for a while and then aborts on 'failed to find block number'.
Sample output includes :

  parent transid verify failed on 22569952096256 wanted 176066 found
  176064
  parent transid verify failed on 22569952096256 wanted 176066 found
  176064
  parent transid verify failed on 20403515183104 wanted 176066 found
  174710
  parent transid verify failed on 20403515183104 wanted 176066 found
  174710
  parent transid verify failed on 1265784008704 wanted 176066 found
  175341
  !-- snip
  bad block 1099696562176
  leaf parent key incorrect 1117248647168
  !-- snip
  Extent back ref already exists for 1130294538240 parent 0 root 2
  Extent back ref already exists for 1130295001088 parent 0 root 2
  !-- snip
  fs uuid d8464857-db87-412e-9d57-ece6c2054f40
  chunk uuid 52a652a3-650d-4dd7-aaa2-6f096a714bbf
          item 0 key (20407857930240 EXTENT_ITEM 4096) itemoff 3944
  itemsize 51
                  extent refs 1 gen 165193 flags 2
                  tree block key (257306671 1 0) level 0
                  tree block backref root 5
          item 1 key (20407857934336 EXTENT_ITEM 4096) itemoff 3893
  itemsize 51
                  extent refs 1 gen 165308 flags 2
                  tree block key (257585950 1 0) level 0
                  tree block backref root 5
  !-- snip
  failed to find block number 20407858008064
  Aborted

Output is exactly the same when run against both devices, even
when using 'btrfsck -s1'.

Should we light a candle and say 'goodbye' to the data or is
there some hope that btrfsck will be able to help us mount the
filesystem ?

Is there any additional information that is useful to the developers ?

The system is based on fedora-14, btrfs-progs-0.19-12.fc14.x86_64,
and the arcmsr module (built from the 1.20.0X.15-100729 sources).

- greg
