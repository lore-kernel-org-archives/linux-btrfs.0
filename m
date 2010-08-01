From: Fabian Kramer <komplexmaster@googlemail.com>
Subject: how can i recover the btrfs after "parent transid verify failed"?
Date: Sun, 1 Aug 2010 15:55:21 +0200
Message-ID: <AANLkTiknZfh5MpGcNmM6_i=S-vJzc7EEVDsWo3oqWR+H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My raid5 crashed, so i changed the old hdd and started the rebuild.
But now i can't mount the btrfs, the mount command frozen and the
kernel give me in a loop the follwing lines:

Jul 29 18:37:04 fileserver kernel: [ 1229.692268]
verify_parent_transid: 2492 callbacks suppressed
Jul 29 18:37:04 fileserver kernel: [ 1229.692274] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.692287] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.696549] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.696564] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.700419] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.700433] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.704392] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.704404] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.708384] parent transid
verify failed on 6975016271872 wanted 204247 found 204249
Jul 29 18:37:04 fileserver kernel: [ 1229.708396] parent transid
verify failed on 6975016271872 wanted 204247 found 204249

Is there any way to revocery the fs?

rgds Fabian Kramer
